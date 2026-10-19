{ config, ... }: {
  programs = {
    devenv = {
      enable = true;
    };

    # A POSIX complaint shell for testing things.
    zsh = {
      enable = true;
      enableCompletion = true;
    };

    # fd is a simple, fast and user-friendly alternative to find
    fd = {
      enable = true;
      hidden = true;
      ignores = [
        ".git/"
        ".devenv/"
        ".venv/"
        "node_modules/"
      ];
    };

    # a fast, modern replacement for grep
    ripgrep = {
      enable = true;
    };

    git = {
      enable = true;
      signing.format = "openpgp";
      settings = {
        user = {
          name = config.my.username;
          email = "rtfsc+atlas@pm.me";
        };

        init = {
          defaultBranch = "master";
        };

        push = {
          autoSetupRemote = true;
        };
      };
    };
  };
}
