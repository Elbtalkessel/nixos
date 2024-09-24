#!/usr/bin/env bash
# Shows tofi menu and runs selected cli app, usually a repl.
# Using default terminal emulator:
#   repl
# With custom emulator:
#   repl alacritty

declare -A map
mKeys() {
  local out=""
  for i in "${!map[@]}"
  do
    out+="$i\n"
  done
  echo $out
}

# Note: key must not have spaces.
map['IPython']='nix run nixpkgs#python312Packages.ipython'
map['NodeJS']='nix run nixpkgs#nodejs'
map['LLama3']='ollama run llama3'
map['Nix']='nix repl'

key=$(printf $(mKeys) | tofi)
if [ "$key" != "" ]
then
  hyprctl dispatch exec "${1:-$TERM} -e sh -c '${map[$key]}'"
fi
