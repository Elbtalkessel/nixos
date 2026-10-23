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
    # Needs `tea login add` with a user-owned token; the MCP token grants no
    # more than the MCP server already has.
    tea
    nix-tree
    nix-diff
    nix-output-monitor
  ];
}
