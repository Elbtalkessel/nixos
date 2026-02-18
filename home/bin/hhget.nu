#!/usr/bin/env -S nu --stdin
# Site health check script

def get-status []: string -> string {
  http get -e -f $in | get status | into string
}

def print-status []: string -> nothing {
  mut v = ""
  let $s = $in
  if ($s == "200") {
    $v = $"(ansi green)($s)(ansi rst)"
  } else {
    $v = $"(ansi red)($s)(ansi rst)"
  }
  print $v
}

def request []: list<string> -> record {
  $in
  | each {|row|
    try {
      print -n $"($row) "
      { url: $row, status: ($row | get-status | tee { print-status }) }
    } catch {|err|
      print -e $"(ansi red)($err.msg)(ansi rst)"
      { url: $row, status: $err.msg }
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
