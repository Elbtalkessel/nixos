#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Minimal

from pathlib import Path
import functools
import argparse
import json
import sys
import subprocess
import tempfile
import os
import typing
import shutil
import enum


XDG_CONFIG_HOME = Path(os.environ["XDG_CONFIG_HOME"])
HYPRPANEL_SETTINGS = XDG_CONFIG_HOME / "hyprpanel" / "config.json"
BASE_DIR = Path(".").parent.parent.absolute()


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


def safe_try(func: typing.Callable[..., str]) -> typing.Callable[..., None]:
    def inner(*args, **kwargs) -> None:
        try:
            r = func(*args, **kwargs)
            sys.stdout.write(r)
        except Exception as e:
            sys.stderr.write(str(e))

    return inner


def get_hyprpanel_config() -> dict:
    with open(HYPRPANEL_SETTINGS, "r") as f:
        return json.loads(f.read())


@safe_try
def nixify_json(config: dict) -> str:
    with tempfile.NamedTemporaryFile() as f:
        f.write(json.dumps(config, sort_keys=True).encode("utf-8"))
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


@safe_try
def unlink_hyprpanel() -> str:
    try:
        target = os.readlink(HYPRPANEL_SETTINGS)
    except OSError:
        raise RuntimeError("not a link or missing")
    with open(target, "r") as f:
        content = f.read()
    os.unlink(HYPRPANEL_SETTINGS)
    with open(HYPRPANEL_SETTINGS, "w") as f:
        f.write(content)
    return "Done!"


@safe_try
def unlink_eww() -> str:
    src_dir = BASE_DIR / "home" / "modules" / "bar" / "eww" / "config"
    dst_dir = XDG_CONFIG_HOME / "eww"
    if os.path.islink(dst_dir):
        os.unlink(dst_dir)
        shutil.copytree(src_dir, dst_dir)
    return "Done"


class Program(enum.StrEnum):
    HYPRPANEL = "hyprpanel"
    EWW = "eww"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=f"{XDG_CONFIG_HOME} controller")
    p_prog = parser.add_subparsers(dest="program")
    p_hyprpanel = p_prog.add_parser(Program.HYPRPANEL)
    p_eww = p_prog.add_parser(Program.EWW)

    p_hyprpanel.add_argument(
        "--nixify",
        "-n",
        action="store_true",
        default=False,
        help=f"Converts {HYPRPANEL_SETTINGS} into nix's attribute set and sends it to stdout.",
    )
    [
        p.add_argument(
            "--unlink",
            "-u",
            action="store_true",
            default=False,
            help=f"Unlinks config files making it writable",
        )
        for p in (p_hyprpanel, p_eww)
    ]

    args = parser.parse_args()
    p = Program(args.program)

    if p == Program.EWW:
        if args.unlink:
            unlink_eww()
    if p == Program.HYPRPANEL:
        if args.nixify:
            nixify_json(unflatten_dict(get_hyprpanel_config()))
        if args.unlink:
            unlink_hyprpanel()
