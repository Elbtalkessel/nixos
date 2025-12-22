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

SETTINGS_JSON = Path("~/.config/hyprpanel/config.json").expanduser()


def deep_merge(src: dict, dst: dict) -> dict:
    for k, v in src.items():
        if isinstance(v, dict):
            node = dst.setdefault(k, {})
            deep_merge(v, node)
        else:
            dst[k] = v
    return dst


def unflatten_dict(flat: dict) -> dict:
    deep = {}
    for k, v in flat.items():
        keys = reversed(k.split("."))
        deep_merge(functools.reduce(lambda x, y: {y: x}, keys, v), deep)
    return deep


def read_config() -> dict:
    with open(SETTINGS_JSON, "r") as f:
        return json.loads(f.read())


def command(func: typing.Callable[..., str]) -> typing.Callable[..., None]:
    def inner(*args, **kwargs) -> None:
        try:
            r = func(*args, **kwargs)
            sys.stdout.write(r)
        except Exception as e:
            sys.stderr.write(str(e))

    return inner


@command
def dump_config(config: dict) -> str:
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


@command
def unlink_config() -> str:
    try:
        target = os.readlink(SETTINGS_JSON)
    except OSError:
        raise RuntimeError("not a link or missing")
    with open(target, "r") as f:
        content = f.read()
    os.unlink(SETTINGS_JSON)
    with open(SETTINGS_JSON, "w") as f:
        f.write(content)
    return "Done!"


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--nixify",
        action="store_true",
        default=False,
        help=f"Converts {SETTINGS_JSON} into nix's attribute set and sends it to stdout.",
    )
    parser.add_argument(
        "--unlink",
        action="store_true",
        default=False,
        help=f"Unlinks {SETTINGS_JSON} making it writable.",
    )
    args = parser.parse_args()

    if args.nixify:
        dump_config(unflatten_dict(read_config()))
    if args.unlink:
        unlink_config()
