#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Minimal

from pathlib import Path
import functools
import argparse
import json
import sys
import subprocess
import tempfile

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


def dump_config(config: dict) -> tuple[str, bool]:
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
        return r.stderr.decode("utf-8"), False
    return r.stdout.decode("utf-8"), True


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--nixify",
        action="store_true",
        default=False,
        help=f"Converts {SETTINGS_JSON} into nix's attribute set.",
    )
    args = parser.parse_args()
    if args.nixify:
        result, ok = dump_config(unflatten_dict(read_config()))
        if not ok:
            sys.stderr.write(result)
        else:
            sys.stdout.write(result)
