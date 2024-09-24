#!/usr/bin/env sh

OPTIONS=$(cat <<-EOF
python312Packages.ipython
nodejs
EOF)
runner() {
  cmd="nix run nixpkgs#$1"
  exec="$TERM -e sh -c $nix"
  hyprctl dispatch exec $exec
}
echo $OPTIONS | tofi | xargs --no-run-if-empty runner
