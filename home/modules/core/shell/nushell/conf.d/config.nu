let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}

# FIXME: move to home/modules/shell/programs/chtsh/
let chtsh_completer = {|spans|
    let q = $spans | last

    let proxy = {|spns|
        let args = (
            $spans
            | slice (1..-2)
            | append :list
            | reverse
            | uniq
            | reverse
        )
        let cache = $"/tmp/chtsh-($args | str join "-").json"
        if not ($cache | path exists) {
            cht.sh ...$args | lines | save $cache
        }
        open $cache
    }

    do $proxy $spans
    | where {|it| (($q | str length) == 0) or $it starts-with $q}
    | each {|row|
    let value = $row
    let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
    if ($need_quote) { $'"($value | str replace --all "\"" "\\\"")"' } else { $value }
  }
}

let completers = {|spans|
    match $spans.0 {
        cht.sh => $chtsh_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.CARAPACE_LENIENT = 1
$env.config = {
    edit_mode: 'vi'
    show_banner: false
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "prefix"
        external: {enable: true, max_results: 50, completer: $completers}
    }
}
