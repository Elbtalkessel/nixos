# The home side of the virt example: the hardware-independent slice of the
# buckets -- identity and shell -- and none of the desktop stack.
#
# `home/environment.nix` is deliberately absent. It sets variables that depend
# on app-specific options (`my.terminal.exe`, `bat`, vagrant), so importing it
# here would pull in more of the tree than this host wants. That coupling is
# exactly what the buckets are meant to make visible.
{
  config,
  ...
}:
{
  imports = [
    ../../modules/home/core/identity/git.nix
    ../../modules/home/core/shell
    ../../modules/home/apps/files/lf
  ];

  home = {
    inherit (config.my) username;
    homeDirectory = "/home/${config.my.username}";

    sessionVariables.EDITOR = config.my.editor;

    # Matches the release this host was created on.
    stateVersion = "24.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
