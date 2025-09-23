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
  };

  xdg.configFile = {
    "ideavim/ideavimrc".source = ../config/ideavim/ideavimrc;
    # Sets filewatcher to patched one
    #"idea/pycharm.properties".text = "idea.filewatcher.executable.path = ${pkgs.fsnotifier}/bin/fsnotifier";
  };

  programs.zed-editor = {
    enable = true;

    # Define extensions for Nix, shell, Docker Compose, etc.
    extensions = [
      "nix"
      "bash"
      "toml"
      "docker-compose"
      "nu"
    ];

    # Add LSPs or helpers for these languages/scripts.
    extraPackages = with pkgs; [
      nixd
      shellcheck
      shfmt
      dockerfile-language-server
      yaml-language-server
    ];
  };
}
