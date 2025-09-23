# Lists all deskop files at known locations.
def main []: nothing -> table {
  ls ...((
    $env.XDG_DATA_DIRS 
    | split row ":" 
    | each {|| $"($in)/applications"}
  ) 
  | append $"($env.XDG_DATA_HOME)/applications"
  | where (path exists)
  )
}
