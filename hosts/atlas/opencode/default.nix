# The opencode and oh-my-openagent configuration for atlas.
#
# It lives under `hosts/` rather than in `modules/home/apps/llm` because it is
# host-specific: the `omen.lan` provider has to name the workstation by its LAN
# address, while on the workstation itself the same provider is `127.0.0.1`. The
# binaries, the plugin and the language servers come from the shared module --
# `home.nix` imports both. This module owns the two config files and the one
# secret they need.
{
  sops-nix,
  config,
  lib,
  ...
}:
{
  imports = [
    sops-nix.homeManagerModules.sops
  ];

  # sops reads and writes next to the XDG config home, so the age key has to be
  # there too. `hosts/atlas/nixos.nix` seeds it from /etc/nixos/age.key during
  # the first system activation.
  sops.age.keyFile = "/home/${config.my.username}/.config/sops/age/keys.txt";

  sops.secrets."gitea/mcp-token" = { };

  # ~/.omo/omo.jsonc -- oh-my-openagent's own settings: agents, categories and
  # the team-mode limits. Deployed verbatim; omo keeps its own state in the rest
  # of ~/.omo, which stays unmanaged.
  home.file.".omo/omo.jsonc".source = ./omo.jsonc;

  # ~/.config/opencode/opencode.jsonc -- the providers, the plugin list and the
  # MCP servers. The @GITEA_TOKEN@ marker becomes a {file:...} reference to the
  # decrypted secret: opencode expands those in `mcp.<name>.environment` while it
  # loads the config (and trims the trailing newline sops leaves behind), so the
  # token itself reaches neither this file nor the Nix store.
  xdg.configFile."opencode/opencode.jsonc".text =
    lib.strings.replaceStrings
      [ "@GITEA_TOKEN@" ]
      [
        "{file:${config.sops.secrets."gitea/mcp-token".path}}"
      ]
      (builtins.readFile ./opencode.jsonc);
}
