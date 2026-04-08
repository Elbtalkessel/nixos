{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      jetbrains-toolbox
      # junie can't use nushell.
      # Patched JetBrains fsnotifier
      # reason: https://github.com/cachix/devenv/issues/1258
      # fix: https://github.com/NixOS/nixpkgs/pull/318358
      # related: https://github.com/JetBrains/intellij-community/pull/2171
      # fsnotifier
    ];
  };

  xdg.configFile = {
    "ideavim/ideavimrc".source = ../config/ideavim/ideavimrc;
    # Sets filewatcher to patched one
    #"idea/pycharm.properties".text = "idea.filewatcher.executable.path = ${pkgs.fsnotifier}/bin/fsnotifier";
  };
}
