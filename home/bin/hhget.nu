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
  }
}

def print-status []: record -> nothing {
  let ok = $in.status == 200
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

# Health check for a site(s).
# Accepts list of new line separated site domain as an argument,
# or from stdout.
# Prints site domain and its status.
# Optionally saves detailed report to a file.
def main [
  --input (-i): string,   # Optioanl input file path, stdin by default.
  --output (-o): string,  # Optional output file path. Must include an extension.
] {
  let r = if ($input != null) { open --raw $input } else { $in }
  | split row "\n"
  | par-each {|in| $in | get-status | tee { print-status } }
}
