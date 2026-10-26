# Per-host profile for atlas.
#
# All `my.*` values for this machine live here. Both trees (NixOS system and
# Home Manager) import this module, so the values are set once and available
# to either side.
#
# Same goes for sops: each host owns its own secrets file (path set by
# flake.nix's `getSopsConfig`) and the per-host age key at `/etc/sops-nix/key.txt`.
{
  config,
  lib,
  ...
}:
let
  isSystem = !(config ? home && config.home ? homeDirectory);
in
{
  sops.secrets = lib.mkMerge [
    # Tree-agnostic declarations -- valid on both NixOS-system and Home
    # Manager trees.
    {
      "opencode/env" = { };
      "ai-gateway/api-key" = { };
      # Consumed by the gitea MCP server via opencode's native {file:...}
      # substitution at load time (see agent.nix).
      "gitea/mcp-token" = { };
    }

    # System tree only -- the home-manager sops secret type rejects
    # `neededForUsers`, so the password-declaration lives behind a tree gate.
    (lib.mkIf isSystem {
      # https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
      "users/${config.my.core.identity.username}/password" = {
        neededForUsers = true;
      };
    })
  ];

  # `my.editor` -- assigned here so both trees seed `home.sessionVariables.EDITOR`.
  my.editor = "nvim";

  # opencode web UI bind. Both trees read it: Home Manager builds
  # `programs.opencode.web.extraArgs` from it, the system tree opens the
  # firewall only when the service binds on every interface.
  my.service.opencode = {
    ip = "0.0.0.0";
    port = 4096;
  };
}
