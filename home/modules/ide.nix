{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      jetbrains-toolbox
      # Patched JetBrains fsnotifier
      # reason: https://github.com/cachix/devenv/issues/1258
      # fix: https://github.com/NixOS/nixpkgs/pull/318358
      # related: https://github.com/JetBrains/intellij-community/pull/2171
      # fsnotifier
    ];

    sessionVariables = {
      # Custom path to the proerties file, see xdg.configFile below.
      # https://intellij-support.jetbrains.com/hc/en-us/articles/207240985-Changing-IDE-default-directories-used-for-config-plugins-and-caches-storage?page=3
      #PYCHARM_PROPERTIES = "/home/risus/.config/idea/pycharm.properties";
    };
  };

  xdg.configFile = {
    "ideavim/ideavimrc".source = ../config/ideavim/ideavimrc;
    # Sets filewatcher to patched one
    #"idea/pycharm.properties".text = "idea.filewatcher.executable.path = ${pkgs.fsnotifier}/bin/fsnotifier";
  };
}
