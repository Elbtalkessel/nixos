let carapace_completer = {|spans|
  carapace $spans.0 nushell ...$spans | from json
}

let zoxide_completer = {|spans|
  $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

let completers = {|spans|
  match $spans.0 {
    cd => $zoxide_completer
    _ => $carapace_completer
  } | do $in $spans
}

$env.config = {
  show_banner: false,
  completions: {
    # case-sensitive completions
    case_sensitive: false

    # set to false to prevent auto-selecting completions
    quick: true

    # set to false to prevent partial filling of the prompt
    partial: true

    # prefix or fuzzy
    algorithm: "fuzzy"

    external: {
      # set to false to prevent nushell looking into $env.PATH to find more suggestions
      enable: true

      # set to lower can improve completion performance at the cost of omitting some options
      max_results: 50
      completer: $completers
    }
  }
} 

def --env lfcd [] {
  let d = (lf -print-last-dir)
  cd $d
}

def n [] {
  run-external $env.EDITOR
}

