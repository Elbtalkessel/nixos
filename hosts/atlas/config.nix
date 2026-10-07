# Per-host profile for atlas.
#
# All `my.*` values for this machine live here. Both trees (NixOS system and
# Home Manager) import this module, so the values are set once and available
# to either side.
#
# Same goes for sops: each host owns its own secrets file (path set in
# flake.nix's `sopsShared`) and the per-host age key at `/etc/sops-nix/key.txt`.
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
    }

    # System tree only -- the home-manager sops secret type rejects
    # `neededForUsers`, so the password-declaration lives behind a tree gate.
    (lib.mkIf isSystem {
      # https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
      "users/${config.my.username}/password" = {
        neededForUsers = true;
      };
    })
  ];

  # `my.username` -- read by `core/nix-settings` (`trusted-users`),
  # `home.homeDirectory`, and the zsh module via `home.homeDirectory`.
  my.username = "atlas";

  # `my.editor` -- assigned here so both trees seed `home.sessionVariables.EDITOR`.
  my.editor = "nvim";
}
