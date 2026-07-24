#!/usr/bin/env python
# Manual pages crawler, mainly created to crawl devenv man pages
# to generate nushell extern completions.

import typing
import re
import argparse
import subprocess


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
        return hash(self.short or self.long)


def get_flags(lines: typing.Sequence[str]) -> typing.Generator[FlagTuple]:
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


def get_subpages(
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


class ManTuple(typing.NamedTuple):
    command: str
    flags: list[FlagTuple]
    topics: list[SubpageTuple]


def extract(command: str) -> ManTuple:
    ignore = ("NAME", "SYNOPSIS", "DESCRIPTION", "OPTIONS")
    flags: list[FlagTuple] = []
    topics: list[SubpageTuple] = []
    for section, content in sections(read_manual(command)):
        if section in ignore:
            continue
        flags.extend(get_flags(content))
        topics.extend(get_subpages(command, content))
    return ManTuple(flags=flags, topics=topics, command=command)


def crawl(manpage: ManTuple) -> list[ManTuple]:
    out = []
    for topic in manpage.topics:
        out.extend(crawl(extract(topic.man)))
    return out


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "command",
        type=str,
        help="Command to check for manpages",
    )
    args = parser.parse_args()
    for page in crawl(extract(args.command)):
        print(page.command)
        for to in page.topics:
            print(to)
        print("*" * 30)


if __name__ == "__main__":
    main()
