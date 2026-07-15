export module equery {
  export def db-file []: nothing -> string {
    $"($env.XDG_STATE_HOME)/equery/db.json"
  }

  export def db-open []: nothing -> record {
    open (db-file) | default {}
  }

  export def db-save []: record -> nothing {
    $in | save -f (db-file)
  }

  def comp-query [] {
    db-open | columns | each {|it| "`" + $it + "`"}
  }

  def email-count []: string -> int {
    notmuch search $in | wc -l | into int
  }

  export def init []: nothing -> record {
    mkdir (db-file | path dirname)
    {} | tee { db-save }
  }

  # Add a new emal query
  export def add [query: string]: nothing -> record {
    let today = (date now | format date "%Y-%m-%d")
    let count = $query | email-count
    db-open
    | insert $query { $today: $count }
    | tee { db-save }
  }

  # Check email query counters.
  export def check [query: string@comp-query] {
    let nv = $query | email-count
    let today = (date now | format date "%Y-%m-%d")
    db-open
    | upsert $query {|it|
      let ov = $it | get $query | get $today
      {
        $today: (if ($nv == $ov) { $ov } else {$nv + $ov})
      }
    }
    | tee { db-save }
    | get $query
  }

  # Remove email query from the list.
  export def remove [query: string@comp-query]: nothing -> record {
    db-open
    | transpose query daily
    | where query != $query
    | transpose --ignore-titles -r -d
    | tee { db-save }
  }

  # Trash messages, useful after gathering statistics.
  export def trash [query: string@comp-query] {
    notmuch tag +trash $query
    notmuch-mailmover
  }

  # Refresh email query database.
  export def refresh [] {
    db-open
    | columns
    | each {|it| {
      query: $it,
      value: (check $it)
    }}
  }

  # Show email query statistics.
  export def show []: nothing -> list<record> {
    let today = (date now | format date "%Y-%m-%d")
    db-open
    | transpose query daily
    | each {|it|
      {
        query: $it.query
        today: ($it.daily | get $today)
        daily: ($it.daily | values | math avg)
      }
    }
  }
}
