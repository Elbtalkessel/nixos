# Per-host profile for atlas.
#
# All `my.*` values for this machine live here. Both trees (NixOS system and
# Home Manager) import this module, so the values are set once and available
# to either side.
{
  # `my.username` -- read by `core/nix-settings` (`trusted-users`),
  # `home.homeDirectory`, and the zsh module via `home.homeDirectory`.
  my.username = "atlas";

  # `my.editor` -- assigned here so both trees seed `home.sessionVariables.EDITOR`.
  my.editor = "nvim";
}
