export def --env --wrapped lfcd [...args] {
  let d = (lf -print-last-dir ...$args)
  cd $d
}

export def --env --wrapped hashit [...args] {
  $in
  | where type == file
  | insert hash {|it| open $it.name | hash md5}
}

# Takes `ls` input and returns duplicated files by calculating their md5 hash.
export def --env --wrapped duplicates [...args] {
  $in
  | hashit
  | group-by hash --to-table
  | insert dupno {|it| $it.items | length}
  | where dupno > 1
  | each {|it| $it.items | sort-by modified -r | slice 1..}
  | flatten
}

# From https://github.com/nushell/nushell/issues/15807
# A ∪ B - items from both collections.
export def union [other: list]: list -> list {
  ($in ++ $other) | uniq
}
# Only items present in A and B collections.
export def intersection [other: list]: list -> list {
  where $it in $other
}
# A items not present in B.
export def difference [other: list]: list -> list {
  where $it not-in $other
}
# Items present only in of of A or B.
export def symmetric-difference [ other: list ]: list -> list {
  let this = $in
  ($this | union $other) | difference ($this | intersection $other)
}

# Takes a table as input and outputs a new line separated text.
# Useful for passing the result as stdin to a custom command.
@example "List of files" {ls | to input name} --result "1.jpg
2.jpg
"
export def "to input" [
  field: string  # Name of a field, should have value of type string.
]: table -> string {
  $in | get $field | str join "\n"
}

# Polls every N a key from /proc/meminfo, returning its value.
# Useful in combination with, for example, ttyplot.
export def memory-watch [
  --key (-k): string = "Dirty",     # /proc/meminfo key to watch
  --refresh (-r): duration = 2sec,  # sample every N .
]: nothing -> list<number> {
  generate {|state|
    let size = (
      grep -e $"($key):" /proc/meminfo
      | awk '{print $2}'
      | into int
    )
    sleep $refresh;
    {out: $size, next: ($state + 1)}
  } 0
}

# Returns a record of changed env variables after running a non-nushell script's contents (passed via stdin), e.g. a bash script you want to "source"
# Source: https://www.nushell.sh/cookbook/foreign_shell_scripts.html#capturing-the-environment-from-a-foreign-shell-script
export def capture-foreign-env [
    --shell (-s): string = /bin/sh # The shell to run the script in (has to support '-c' argument and POSIX 'env', 'echo', 'eval' commands)
    --arguments (-a): list<string> = [] # Additional command line arguments to pass to the foreign shell
] {
    let script_contents = $in;
    let env_out = with-env { SCRIPT_TO_SOURCE: $script_contents } {
        ^$shell ...$arguments -c `
        env
        echo '<ENV_CAPTURE_EVAL_FENCE>'
        eval "$SCRIPT_TO_SOURCE"
        echo '<ENV_CAPTURE_EVAL_FENCE>'
        env -0 -u _ -u _AST_FEATURES -u SHLVL` # Filter out known changing variables
    }
    | split row '<ENV_CAPTURE_EVAL_FENCE>'
    | {
        before: ($in | first | str trim | lines)
        after: ($in | last | str trim | split row (char --integer 0))
    }

    # Unfortunate Assumption:
    # No changed env var contains newlines (not cleanly parseable)
    $env_out.after
    | where { |line| $line not-in $env_out.before } # Only get changed lines
    | parse "{key}={value}"
    | transpose --header-row --as-record
    | if $in == [] { {} } else { $in }
}

# 256 color palette cheatsheet.
export def colors [] {
  for i in 0..255 {
    # Use white for first 20 colors and black for the rest 16.
    let fg = if $i mod 36 in 0..15 { 0 } else { 15 }
    printf "\x1b[48;5;%s;38;5;%sm %3d \e[0m" $i $fg $i
    # Ignoring first 15 break on every 6 element,
    # this gives 6x6 color cubes.
    if (($i - 15) mod 6 == 0) {
      printf "\n"
    }
  }
}
