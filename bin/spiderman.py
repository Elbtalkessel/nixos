#!/usr/bin/env python
# Manual pages crawler, mainly created to crawl devenv man pages
# to generate nushell extern completions.

import typing
import re
import argparse
import subprocess


class Arguments(typing.NamedTuple):
    command: str


def read_manual(cmd: str) -> typing.Generator[str]:
    v = subprocess.Popen(["man", cmd], stdout=subprocess.PIPE)
    if v.stderr:
        raise RuntimeError(b"".join(v.stderr.readlines()).decode("utf-8"))
    if out := v.stdout:
        return (
            l
            for l in (s.decode("utf-8").strip("\n") for s in out.readlines())
            if l.strip()
        )
    raise RuntimeError(f"man {cmd} return nothing")


def sections(lines: typing.Generator[str]) -> typing.Generator[tuple[str, list[str]]]:
    rgx = re.compile(r"^[A-Z][A-Z ]+$")
    content: list[str] = []
    for line in lines:
        if not rgx.search(line):
            content.append(line)
            continue
        if content:
            yield line, content
        content = []


class FlagTuple(typing.NamedTuple):
    short: typing.Optional[str]
    long: typing.Optional[str]
    args: typing.Optional[str]
    desc: list[str]

    def __str__(self) -> str:
        tok = []
        if self.long and self.short:
            tok.extend((self.long, f"({self.short})"))
        else:
            tok.append(self.long or self.short)
        if self.desc:
            tok.append(f"# {self.desc[0]}")
        return " ".join(tok)

    def __hash__(self) -> int:
        return hash((self.short, self.long))


def flags(lines: typing.Sequence[str]) -> typing.Generator[FlagTuple]:
    rgx = re.compile(
        r"^(?:(?P<short>-[\w])(?:, )?)?(?P<long>--[^ ]+)?\s?(?P<args>.*)?$"
    )
    desc: list[str] = []
    head = (None, None, None)
    for line in lines:
        if line.startswith("     -"):
            m = rgx.search(line.strip())
            assert m
            if head != (None, None, None):
                yield FlagTuple(*head, desc=desc)
            head = m.groups()
            continue
        desc.append(line.strip())


class SubpageTuple(typing.NamedTuple):
    subcommand: str
    man: str
    desc: list[str]

    def __str__(self) -> str:
        tok = [self.subcommand]
        if self.desc:
            tok.append(f"# {self.desc[0]}")
        return " ".join(tok)

    def __hash__(self) -> int:
        return hash((self.man,))


def subpages(
    command: str, lines: typing.Sequence[str]
) -> typing.Generator[SubpageTuple]:
    rgx = re.compile(rf"     ({command}-([^(]+))\(\d+\)$")
    subcommand = None
    man = None
    desc: list[str] = []
    for line in lines:
        if s := rgx.search(line):
            if man and subcommand:
                yield SubpageTuple(subcommand=subcommand, man=man, desc=desc)
                desc = []
            man, subcommand = s.group(1), s.group(2)
            continue
        desc.append(line.strip())


def crawl(
    args: Arguments,
    seen_flags: set[FlagTuple] = set(),
    seen_topic: set[SubpageTuple] = set(),
) -> tuple[set[FlagTuple], set[SubpageTuple]]:
    ignore = ("NAME", "SYNOPSIS", "DESCRIPTION", "OPTIONS")
    for section, content in sections(read_manual(args.command)):
        if section in ignore:
            continue

        for l in flags(content):
            if l in seen_flags:
                continue
            seen_flags.add(l)

        for l in subpages(args.command, content):
            if l in seen_topic:
                continue
            seen_topic.add(l)
            f, t = crawl(Arguments(l.man), seen_flags, seen_topic)
            seen_flags = seen_flags | f
            seen_topic = seen_topic | t

    return seen_flags, seen_topic


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "command",
        type=str,
        help="Command to check for manpages",
    )
    args = typing.cast(Arguments, parser.parse_args())
    manflags, mantopics = crawl(args)
    for flag in manflags:
        print(flag)
    for topic in mantopics:
        print(topic)


if __name__ == "__main__":
    main()
