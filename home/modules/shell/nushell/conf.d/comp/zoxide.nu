def "nu-complete zoxide path" [context: string] {
  let parts = $context | str trim --left | split row " " | skip 1 | each { str downcase }
  let completions = (
  ^zoxide query --list --exclude $env.PWD -- ...$parts
  | lines
  | each {|dir|
    if ($parts | length) <= 1 {
      $dir
    } else {
      let dir_lower = $dir | str downcase
      let rem_start = $parts | drop 1 | reduce --fold 0 { |part, rem_start|
        ($dir_lower | str index-of --range $rem_start.. $part) + ($part | str length)
      }
      {
        value: ($dir | str substring $rem_start..),
        description: $dir
      }
    }
  })
  {
    options: {
      sort: false,
      completion_algorithm: substring,
      case_sensitive: false,
    },
    completions: $completions,
  }
}

# Semi-working, annoying, cd is alias to __zoxide_z, z calls
# alias, completion doesn't quote suggestion, I can't wrap cd function
# because it shadowed(?) by zoxide alias, when I alias zoxide to z, for example,
# it complains that __zoxide_z or z alias is not defined.
# Adding it to external completer doesn't help.
# I saw somewhere that providing a completer to an alias in nushell is
# broken, but, fuck it, maybe later.
def --env z [path: string@"nu-complete zoxide path"] {
  cd $path
}
