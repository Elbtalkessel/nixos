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
  let status = http get -e -f $in | get status
  let elapsed = (date now) - $start
  {
    output: ($status | into string),
    time: ($elapsed | into string),
  }
}

def print-status []: record -> nothing {
  let $s = $in.output
  let $t = $in.time
  let $v = if ($s == "200") { _s $s } else { _e $s }
  print $"(_i $t) ($v)"
}

def request []: list<string> -> record {
  $in
  | each {|row|
    try {
      print -n $"($row) "
      let r = $row | get-status | tee { print-status }
      { url: $row, status: $r.output, time: $r.time }
    } catch {|err|
      print -e (_e $err.msg)
      { url: $row, status: $err.msg, time: 0sec }
    }
  }
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
  if ($input != null) { open --raw $input } else { $in }
  | split row "\n"
  | request
  | collect
  | tee {|| if ($output != null) { $in | save -f $output }}
  | ignore
}
