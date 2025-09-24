#!/usr/bin/env nu

let BASE_URL = "api.waifu.im"

let TAGS = "/tags"
let SEARCH = "/search"

let HEADERS = {
  "Content-Type": "application/json",
  "Accept-Version": "v6"
}


def get-url [path: string, params = {}]: nothing -> string {
  {
    "scheme": "https",
    "host": $BASE_URL,
    "path": $path,
    "params": $params
  } | url join
}

def get-tags []: nothing -> list {
  let cache = $"/tmp/waifu.nu.tags.json"

  if ($cache | path exists) {
    let cached = ($cache | open)
    if ($cached != null) {
      return $cached
    }
    rm $cache
  }

  http get (get-url $TAGS {"full": true}) --headers $HEADERS
  | values 
  | flatten
  | tee { to json | save $cache }
}


# Search for an image(s)
# https://docs.waifu.im/reference/api-reference/search#search-images.
# Input: query params, Output: a list of image records.
def get-search [params = {}]: nothing -> list {
  http get (get-url $SEARCH $params) --headers $HEADERS 
  | get "images"
}


def tag-display []: list -> list {
  $in | enumerate | flatten | each {|| 
    $"#($in.index): ($in.description) [($in.name)(if ($in.is_nsfw) { ', nsfw' } else { ', sfw' })]"
  }
}


def tags-select []: nothing -> list {
  let tags = (get-tags)
  $tags 
    | tag-display
    | str join "\n"
    | fzf -m --header "Select a tag(s)" --footer "Tab to toggle, enter to select"
    | lines
    | each {|s| 
      $tags 
      | get (
        $s | parse "#{index}: {description} [{tags}]"
        | get index 
        | first
        | into int
      )
    }
}


# creates a filename from search response item
def get-filename [item: record]: nothing -> string {
  (
    ["waifu", (if $item.is_nsfw { "nsfw" } else { "sfw" })]
    | append ($item.tags | each {|| $in.name})
    | append [$"($item.width)x($item.height)", $item.signature]
    | str join "."
  ) + $item.extension
}


# https://docs.waifu.im/reference/api-reference/tags
# Returns flatten, without top level keys result.
def "main tags" [] {
  tags-select
}

def "main search" [] {
  let tags = (tags-select | get name)
  mut saved = [];
  loop {
    clear
    get-search { "included_tags": $tags }
    | each {||
      let p = (["~/Pictures/waifu", (get-filename $in)] | path join)
      http get $in.url
      | tee { save $p }
      | tee {|| notify-send "Saved" $p}
      | imv -
    }
  }
}

def main [] {
  
}
