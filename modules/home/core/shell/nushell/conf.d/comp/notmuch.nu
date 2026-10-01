export extern "notmuch search" [
  --help
  --format: string@[json sexp text text0]
  --format-version: number
  --output: string@[summary threads messages files tags]
  --sort: string@[newest-first oldest-first]
  --offset: number # [-]N Skip  displaying  the  first N results. With the leading '-', start at the Nth result from the end.
  --limit: number
  --exclude: string@["true" "false" "all" "flag"]
  --duplicate: number
  ...args
]
