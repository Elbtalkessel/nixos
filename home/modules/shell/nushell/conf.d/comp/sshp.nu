def "nu-complete local files" [] {
    ^ls | lines
}

def "nu-complete ssh identity" [] {
  ls ~/.ssh/id_*
  | where {|f|
      ($f.name | path parse | get extension) != "pub"
    }
  | get name
}

export extern "sshp" [
  --anonymous(-a) # Hide hostname prefix, defaults to false.
  --color(-c): string@[on off auto] # Set color output, defaults to auto.
  --debug(-d) # Enable debug info, defaults to false.
  --exit-codes(-e) # Show command exit codes, defaults to false.
  --file(-f): string@"nu-complete local files" # A file of hosts separated by newlines, defaults to stdin.
  --group(-g) # Group output by hostname (group mode).
  --help(-h) # Print this message and exit.
  --join(-j) # Join hosts together by output (join mode).
  --max-jobs(-m): int # Max processes to run concurrently, defaults to 50.
  --dry-run(-n) # Don't actually execute subprocesses.
  --silent(-s) # Silence all output subprocess stdio, defaults to false.
  --trim(-t) # Trim hostnames (remove domain) on output, defaults to false.
  --version(-v) # Print the version number and exit.
  --exec(-x) # Program to execute, defaults to ssh.
  --max-line-length: int # Maximum line length (in line mode only), defaults to 1024.
  --max-output-length: int # Maximum output length (in join mode only), defaults to 8192.
  --identity(-i): string@"nu-complete ssh identity" # ssh identity file to use.
  --login(-l): string # The username to login as.
  --option(-o): string # ssh option passed in key=value form.
  --port(-p): int # The ssh port.
  --quiet(-q) # Run ssh in quiet mode.
]
