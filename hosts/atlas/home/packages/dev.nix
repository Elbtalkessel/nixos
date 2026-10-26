{ pkgs, ... }:
{
  # The repo gates and the tooling to read their output. On PATH outside a
  # project's devenv shell, which is where an agent starts.
  home.packages = with pkgs; [
    # RFC style, the same formatter the git hook and CI check with.
    nixfmt
    statix
    deadnix
    shellcheck
    jq
    yq-go
    nix-tree
    nix-diff
    nix-output-monitor
  ];
}
