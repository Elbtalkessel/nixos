_: {
  imports = [
    ../home/modules/lf.nix
    ../home/modules/git.nix
  ];

  home = {
    stateVersion = "24.11";

    username = "risus";
    homeDirectory = "/home/risus";

    packages = [
      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    shellAliases = {
      n = "nvim";
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
