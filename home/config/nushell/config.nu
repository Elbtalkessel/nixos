let carapace_completer = {|spans|
  carapace $spans.0 nushell ...$spans | from json
}

let zoxide_completer = {|spans|
  # Spans is command array, likely ["cd", "<arg>"]
  # Why do we even pipe $spans?
  $spans 
    # Skip "cd" part.
    | skip 1
    # In current dir, list all nodes, pick only directories.
    # If second arg is passed, filter dir names by it. Finally list names only.
    # What about symlinks?
    | "./" + ($env.PWD | path basename)
    | ls -a
    | where type == dir and ($spans.1 == "" or name =~ $spans.1)
    | get name 
    # Query zoxide, append result and filter-out non-unique records.
    | append ( zoxide query -l $spans.1 --exclude $env.PWD | lines ) 
    | uniq
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
    # using prefix because fuzzy doesn't work well with "cd <tab>"
    algorithm: "prefix"

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

def nn [] {
  nix run ~/code/nix/nixvim
}
