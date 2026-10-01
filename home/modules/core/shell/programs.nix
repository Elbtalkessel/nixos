{ config, pkgs, ... }:
{
  programs = {
    # file database for nixpkgs
    # usage example: `nix-locate 'bin/hello'`
    nix-index = {
      # Disabled until I find how to disable nushell
      # integration for searching a package when a command
      # mistyped (annoying delay.)
      enable = false;
    };

    devenv = {
      enable = true;
    };

    # A POSIX complaint shell for testing things.
    zsh = {
      enable = true;
      dotDir = "${config.home.homeDirectory}/zsh";
      enableCompletion = true;
      shellAliases = config.home.shellAliases // {
        ls = "ls --color=auto";
      };
      fastSyntaxHighlighting.enable = true;
    };

    # "Smarter" cd, tracks visited directories and allows to jump back by typing its name without full path
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };

    # Devenv "soft" dependency, automatically uses devenv on "cd"
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
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

    # fuzzy finder, able to walk directories or read from stdin
    fzf = {
      enable = true;
    };

    # a fast, modern replacement for grep
    ripgrep = {
      enable = true;
    };

    bat = {
      enable = true;
      syntaxes = {
        nushell = {
          src = pkgs.fetchFromGitHub {
            owner = "kurokirasama";
            repo = "nushell_sublime_syntax";
            rev = "main";
            hash = "sha256-2A7c6/FOsOyzyGAshZJZvZ/m5w1cKj7uckB+pzdlr3M=";
          };
          file = "nushell.sublime-syntax";
        };
      };
    };
  };
  home.shellAliases.cat = "bat";
}
