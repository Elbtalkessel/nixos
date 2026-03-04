#!/usr/bin/env nu

def load-settings []: nothing -> record {
  # content required:
  # default:
  #   user:
  #     id: <youtrack user id>
  #     token: <permanent youtrack api token>
  #     baseURL: <your instance url + /api>
  open $"($env.XDG_CONFIG_HOME)/youtrack-cli/settings.yaml"
}

def get-headers []: record -> record {
  { Authorization: $"Bearer ($in.default.user.token)", Accept: "application/json" }
}

def "main spent-today" []: nothing -> string {
  let s = load-settings
  let now = date now
  let today = $now | format date "%Y-%m-%d"
  let tomorrow = ($now + 1day) | format date "%Y-%m-%d"
  let fields = "duration(minutes)"
  let url = $"($s.default.user.baseURL)/workItems?author=($s.default.user.id)&startDate=($today)&endDate=($tomorrow)&fields=($fields)"
  let spent = http get $url --headers ($s | get-headers) | get duration | get minutes | reduce --fold 0 {|acc, it| $acc + $it}
  $"($spent)min" | into duration | into string
}

def main [] {}
