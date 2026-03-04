#!/usr/bin/env nu

# Base

def settings-file []: nothing -> string {
  $"($env.XDG_CONFIG_HOME)/youtrack-cli/settings.yaml"
}

def askfor [key: string, default: string]: nothing -> string {
  let default_ = if ($default != "") { $" \(($default)\)" } else {""}
  print -n $"($key)($default_): "
  input --default $default | str trim
}

# end base ---

# API Client

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

# end API Client ---


# Targets

# Amount of time tracked today.
def "main spent-today" []: nothing -> string {
  open (settings-file)
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

# Creates / updates a settings file
def "main init" []: nothing -> nothing {
  let sf = settings-file

  let s = if ($sf | path exists) {
    open $sf
  } else {
    {
      name: "YouTrack Config",
      default: {
        user: {
          id: "",
          token: "",
        },
        baseURL: "",
      },
    }
  }
  $s
  | merge {
    default: {
      baseURL: (askfor "YouTrack instance URL (without schema)" $s.default.baseURL),
      user: {
        id: (askfor "YouTrack user ID" $s.default.user.id),
        token: (askfor "YouTrack API Token" $s.default.user.token),
      },
    },
  }
  | to yml
  | save -f $sf
  print $"($sf) updated"
}

# end Targets

def main [] {}
