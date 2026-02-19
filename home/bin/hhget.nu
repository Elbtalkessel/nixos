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

def get-status []: string -> record {
  let start = date now
  let status = $in | try {
    http get -e -f $in | get status
  } catch {|err|
    $err.msg
  }
  let elapsed = (date now) - $start
  {
    url: $in,
    status: $status,
    time: $elapsed,
    ok: ($status < 400),
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

# Site health check.
# Parameters and flags
def main [
  ...domain: string,      # Domains to check.
  --input (-i): string,   # Newline separated list of domains to check.
  --output (-o): string,  # Dump results in a file, (.csv, .yaml, .md, .json).
]: [nothing -> nothing, string -> nothing] {
  if ($input != null) {
    open --raw $input | lines
  } else if ($domain != null) {
    $domain
  } else {
    $in | lines
  }
  | par-each {|in| $in | get-status | tee { print-status } }
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
