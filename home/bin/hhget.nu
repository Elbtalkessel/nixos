#!/usr/bin/env -S nu --stdin
# Site health check script

def _s [v: string] {
  $"(ansi green)($v)(ansi rst)"
}

def _e [v: string] {
  $"(ansi red)($v)(ansi rst)"
}

def _i [v: string] {
  $"(ansi d)($v)(ansi rst)"
}

def get-status [timeout: duration]: string -> record {
  let start = date now
  let status = $in | try {
    let m = if ($timeout == -1sec) { Infinity | into duration } else { $timeout }
    http get -e -f -m $m $in | get status
  } catch {|err|
    $err.msg
  }
  let elapsed = (date now) - $start
  {
    url: $in,
    # TODO: only numerical status code,
    #   error message should go into a separate filed.
    status: $status,
    time: $elapsed,
    ok: ((($status | describe) == "int") and ($status < 400)),
  }
}

def print-status []: record -> nothing {
  let ok = $in.ok
  [
    $in.url
    (
      $in
      | if ($ok) {
        _s ($in.status | into string)
      } else {
        _e ($in.status | into string)
      }
    )
    (_i ($in.time | format duration sec))
  ]
  | str join " "
  | if ($ok) { print $in } else { print -e $in }
  | ignore
}


def together [list: list<string>, stdin: string = ""] {
  $list
  | append ($stdin | lines)
  | each {|it|
    if (($it | path type) == "file") {
      open --raw $it | lines
    } else {
      $it
    }
  }
  | flatten
}

# Turns an output file into <url>: { ... } map.
def into-mapping []: list<record> -> record {
  $in
  | reduce --fold {} {|it, acc|
    if ($it.url in $acc) {
      $acc
    } else {
      $acc | insert $it.url $it
    }
  }
}


# Merges two output files ignoring duplicated urls.
# Returns json.
def "main merge" [a: string, b: string]: nothing -> string {
  open $a
  | into-mapping
  | merge deep (open $b | into-mapping)
  | values
  | to json
}


# Site health check.
# Accepts new line domain list or file list from stdin
# and as the first positional argument.
# Example:
#   # Check ddg.gg, goo.gl and everything in the file.txt
#   "ddg.gg" | hhget goo.gl ./file.txt
def main [
  ...domain: string, # Domain list, file list.
  --output (-o): string, # Dump results in a file, (.csv, .yaml, .md, .json).
  --timeout (-t): duration = -1sec, # Timeout for a request.
  --threads (-p): int = 4, # THe number of threads to use.
]: [nothing -> nothing, string -> nothing] {
  together $domain $in
  | par-each --threads $threads {|in|
    $in
    | get-status $timeout | tee { print-status }
  }
  | collect
  | tee {$in | if ($output != null) { save -f $output }}
  | tee {|in|
    if (($in | length) == 0) {
      return
    }
    printf '%*s\n' $"(tput cols)"  | tr ' ' '-'
    $in
    | {
      "num": ($in | length),
      "err": ($in | where not ok | length)
      "avg": (($in | get time | math avg | format duration sec)),
      "min": (($in | get time | math min | format duration sec)),
      "max": (($in | get time | math max | format duration sec)),
      }
    | transpose
    | to csv --separator '\t' --noheaders
    | print
  }
  | ignore
}
