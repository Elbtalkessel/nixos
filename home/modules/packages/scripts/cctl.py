from pathlib import Path
import functools
import argparse
import json
import sys
import subprocess
import tempfile
import os
import enum
import logging
import traceback
import re
from typing import Callable, Generator, Iterable


logger = logging.getLogger(__name__)


def _deep_merge(src: dict, dst: dict):
    """
    Exceedingly inefficient deep dict in-place merger.
    Only merges dicts, lists will shallow copied to the destionation.

    :param src: Source dictionary.
    :param dst: Destination dictionary.
    """
    for k, v in src.items():
        if isinstance(v, dict):
            node = dst.setdefault(k, {})
            _deep_merge(v, node)
        else:
            dst[k] = v


def _unflatten_dict(flat: dict) -> dict:
    """
    Converts flat, dot separated dicts into nested one.

    Example:
    >>> unflatten_dict({"a.b": 1, "a.z": 2})
    {"a": {"b": 1, "z": 2}}
    """
    deep = {}
    for k, v in flat.items():
        keys = reversed(k.split("."))
        _deep_merge(functools.reduce(lambda x, y: {y: x}, keys, v), deep)
    return deep


def _norm_json(path: Path) -> dict:
    """
    Turns JSONC to regular JSON removing comments.
    """
    return json.loads(re.sub(r"(?m)^//.*\n?", "", path.read_text()))


def _norm_ext(path: Path) -> str:
    """
    Verifies that a path has extension.
    Changes .jsonc to .json
    """
    ext = path.suffix.replace(".", "")
    if not ext:
        raise RuntimeError(f"cannot get file extensions from {path}")
    if ext == "jsonc":
        ext = "json"
    return ext


def _nixify_any(path: Path) -> str:
    ext = _norm_ext(path)
    r = subprocess.run(
        [
            "nix",
            "eval",
            "--expr",
            f"builtins.from{ext.upper()} (builtins.readFile {path})",
            "--impure",
        ],
        capture_output=True,
    )
    if r.returncode != 0:
        raise RuntimeError(r.stderr.decode("utf-8"))
    return r.stdout.decode("utf-8")


def _nixify_json(path: Path) -> str:
    config = _unflatten_dict(_norm_json(path))
    with tempfile.NamedTemporaryFile(suffix=".json") as f:
        content = json.dumps(config, sort_keys=True).encode("utf-8")
        f.write(content)
        f.flush()
        return _nixify_any(Path(f.name))


def nixify(path: Path) -> str:
    if path.suffix in ("json", "jsonc"):
        return _nixify_json(path)
    return _nixify_any(path)


def unlink(path: Path) -> str:
    """
    Unlinks `path` replacing link with target's content.
    """
    try:
        target = os.readlink(path)
    except OSError:
        raise RuntimeError("not a link or missing")
    with open(target, "r") as f:
        content = f.read()
    os.unlink(path)
    with open(path, "w") as f:
        f.write(content)
    return path.name


class PTopic(enum.StrEnum):
    UNLINK = "unlink"
    NIXIFY = "nixify"
    JSON_NORM = "json-norm"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="NixOS config artificats management.")
    _reg = parser.add_subparsers(dest="topic")

    p_unlink = _reg.add_parser(
        name=PTopic.UNLINK,
        help="Unlink a config file.",
    )
    p_nixify = _reg.add_parser(
        name=PTopic.NIXIFY,
        help="Turns a json file into nix attribute set.",
    )
    p_json_norm = _reg.add_parser(
        name=PTopic.JSON_NORM,
        help="Prints normalized json content.",
    )

    p_unlink.add_argument("path", help="Path to unlink.", nargs="*")
    p_nixify.add_argument("path", help="Path to nixify.", nargs="*")
    p_json_norm.add_argument("path", help="Path to a json file", nargs="*")

    args = parser.parse_args()
    t = PTopic(args.topic)

    def every(paths: Iterable[str], cb: Callable[[Path], str]) -> Generator[str]:
        """
        Nargs support, calls `cb` for every path.
        """
        for str_path in paths:
            path = Path(str_path)
            pfx = f"{os.path.basename(path)}: "
            try:
                yield f"{pfx}{cb(path)}"
            except Exception:
                logger.exception(f"cannot parse {path}")

    def run() -> Generator[str]:
        if t not in PTopic:
            raise RuntimeError("Wrong topic")
        elif t == PTopic.UNLINK:
            yield from every(args.path, unlink)
        elif t == PTopic.NIXIFY:
            yield from every(args.path, nixify)
        elif t == PTopic.JSON_NORM:
            yield from every(
                (p for p in args.path if "json" in p),
                lambda p: json.dumps(_norm_json(p)),
            )

    try:
        for r in run():
            sys.stdout.write(r)
        sys.exit(0)
    except Exception:
        sys.stderr.write(traceback.format_exc())
        sys.exit(1)
