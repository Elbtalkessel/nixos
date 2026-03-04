#!/usr/bin/env nu

def load-settings []: nothing -> record {
  # content required:
  # default:
  #   user:
  #     id: <youtrack user id>
  #     token: <permanent youtrack api token>
  #   baseURL: <your instance url + /api>
  open $"($env.XDG_CONFIG_HOME)/youtrack-cli/settings.yaml"
}

def get-headers []: record -> record {
  { Authorization: $"Bearer ($in.default.user.token)", Accept: "application/json" }
}

# Creates an absolute URL for given path.
def get-url [path: string, query = {}]: record -> string {
  {
    "scheme": "https",
    "host": $in.default.baseURL,
    "path": ("/api" + $path),
    "params": (
      $query
      | transpose k v
      | where $it.v != null
      | reduce -f {} {|i,a| $a | insert $i.k $i.v}
    )
  }
  | url join
}

# Performs request to YouTrack API.
def client-get [path: string, query = {}]: record -> record {
  http get ($in | get-url $path $query) --headers ($in | get-headers)
}

# Builds GET query parameters for filtering by a date range.
def range-filter [start: datetime, endOffset: duration]: nothing -> record {
  let dfmt = "%Y-%m-%d"
  {
    startDate: ($start | format date $dfmt),
    endDate: (($start + $endOffset) | format date $dfmt)
  }
}

# Amount of time tracked today.
def "main spent-today" []: nothing -> string {
  load-settings
  | client-get "/workItems" (
    {
      author: $in.default.user.id,
      fields: "duration(minutes)"
    }
    | merge (range-filter (date now) 1day)
  )
  | get duration
  | get minutes
  | reduce --fold 0 {|acc, it| $acc + $it}
  | into duration --unit min
  | into string
}

def main [] {}
