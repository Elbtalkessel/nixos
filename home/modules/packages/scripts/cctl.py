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


logger = logging.getLogger(__name__)
XDG_CONFIG_HOME = Path(os.environ["XDG_CONFIG_HOME"])
FAIL = object()


def deep_merge(src: dict, dst: dict):
    """
    Exceedingly inefficient deep dict in-place merger.
    Only merges dicts, lists will shallow copied to the destionation.

    :param src: Source dictionary.
    :param dst: Destination dictionary.
    """
    for k, v in src.items():
        if isinstance(v, dict):
            node = dst.setdefault(k, {})
            deep_merge(v, node)
        else:
            dst[k] = v


def unflatten_dict(flat: dict) -> dict:
    """
    Converts flat, dot separated dicts into nested one.

    Example:
    >>> unflatten_dict({"a.b": 1, "a.z": 2})
    {"a": {"b": 1, "z": 2}}
    """
    deep = {}
    for k, v in flat.items():
        keys = reversed(k.split("."))
        deep_merge(functools.reduce(lambda x, y: {y: x}, keys, v), deep)
    return deep


def read_json_config(path: Path) -> dict:
    with open(path, "r") as f:
        content = f.read()
        return json.loads(re.sub(r"(?m)^//.*\n?", "", content))


def nixify_json(config: dict) -> str:
    with tempfile.NamedTemporaryFile() as f:
        content = json.dumps(config, sort_keys=True).encode("utf-8")
        f.write(content)
        f.flush()
        r = subprocess.run(
            [
                "nix",
                "eval",
                "--expr",
                f"builtins.fromJSON (builtins.readFile {f.name})",
                "--impure",
            ],
            capture_output=True,
        )
    if r.returncode != 0:
        raise RuntimeError(r.stderr.decode("utf-8"))
    return r.stdout.decode("utf-8")


def unlink(path: Path) -> None:
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


class PTopic(enum.StrEnum):
    UNLINK = "unlink"
    NIXIFY = "nixify"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=f"{XDG_CONFIG_HOME} controller")
    p_topic = parser.add_subparsers(dest="topic")

    p_unlink = p_topic.add_parser(
        name=PTopic.UNLINK,
        help="Unlink a config file.",
    )
    p_nixify = p_topic.add_parser(
        name=PTopic.NIXIFY,
        help="Turns a json file into nix attribute set.",
    )

    p_unlink.add_argument("path", help="Path to unlink.")
    p_nixify.add_argument("path", help="Path to nixify.")

    args = parser.parse_args()
    t = PTopic(args.topic)

    def run() -> str:
        path = Path(args.path)
        if t == PTopic.UNLINK:
            unlink(path)
            return f"{args.path} is writable now"
        if t == PTopic.NIXIFY:
            return nixify_json(read_json_config(path))
        raise RuntimeError("Wrong topic")

    try:
        sys.stdout.write(run())
        sys.exit(0)
    except Exception:
        sys.stderr.write(traceback.format_exc())
        sys.exit(1)
