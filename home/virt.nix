{ config, ... }:
{
  imports = [
    ../home/modules/lf.nix
    ../home/modules/git.nix
    ../home/modules/shell.nix
  ];

  home = {
    stateVersion = "24.11";

    inherit (config) username;
    homeDirectory = "/home/${config.username}";

    packages = [
      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    sessionVariables = {
      EDITOR = config.editor;
    };

    shellAliases = {
      n = config.editor;
      s = "sudo";
      S = "sudo systemctl";
      Su = "systemctl --user";
      Sr = "sudo systemctl restart";
      cp = "cp -iv";
      ln = "ln -v";
      mv = "mv -iv";
      rm = "rm -v";
    };
  };

  programs.home-manager.enable = true;
}
