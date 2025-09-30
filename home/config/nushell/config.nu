let carapace_completer = {|spans|
  carapace $spans.0 nushell ...$spans | from json
}

let zoxide_completer = {|spans|
  # Spans is command array, likely ["cd", "<arg>"]
  let q = ($spans | last)

  # In current dir, list all nodes, pick only directories.
  # filter-out by $q (if passed) and list names only.
  # TODO: exclude symlinks to files.
  # TODO: would be nicer to output paths relative to current directory.
  "./" + ($env.PWD | path basename)
  | ls -a
  # It seems nushell can't filter if we swap params, ex:
  # `where name =~ $q` vs. `$q in name` have different meaning.
  # I prefer using `in` instead of regex `=~`.
  | where {|x| $q in $x.name and $x.type in [dir, symlink]}
  | get name 
  # Query zoxide, append result and filter-out non-unique records.
  | append ( zoxide query -l $q --exclude $env.PWD | lines ) 
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

def --env --wrapped lfcd [...args] {
  let d = (lf -print-last-dir ...$args)
  cd $d
}

def n [] {
  run-external $env.EDITOR
}

