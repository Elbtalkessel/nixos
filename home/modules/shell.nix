{ lib, pkgs, ... }:

rec {
  # Everything related to the shell

  home.packages = with pkgs; [
    # CLI for searching packages on search.nixos.org
    nix-search-cli
  ];

  programs = {
    # file database for nixpkgs
    # usage example: `nix-locate 'bin/hello'`
    nix-index = {
      enable = true;
      # Provides command-not-found script
      # Example:
      #   $ blender
      #     The program 'blender' is currently not installed. You can install it
      #     by typing:
      #       nix-env -iA nixpkgs.blender.out
      #     Or run it once with:
      #       nix-shell -p blender.out --run ...
      enableZshIntegration = programs.zsh.enable;
    };

    zsh = {
      enable = false;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      prezto = {
        enable = true;
        editor = {
          dotExpansion = true;
          keymap = "vi";
        };
      };
    };

    nushell = {
      enable = true;
      # for editing directly to config.nu 
      configFile.source = ../config/nushell/config.nu;
      plugins = [
        (pkgs.callPackage (pkgs.fetchFromGitHub {
          owner = "Elbtalkessel";
          repo = "nu_plugin_bg";
          rev = "v0.5.0";
          hash = "sha256-jtCIcpuTp0SFEr9Jd9mbhUpQaKnEByJ0PSwz2I9g/CI=";
        }) { })
      ];
    };
    carapace.enable = programs.nushell.enable;
    carapace.enableNushellIntegration = programs.nushell.enable;

    # "Smarter" cd, tracks visited directories and allows to jump back by typing its name without full path
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
      enableZshIntegration = programs.zsh.enable;
      enableNushellIntegration = programs.nushell.enable;
    };

    # Better "ls"
    eza = {
      enable = programs.zsh.enable;
      enableZshIntegration = programs.zsh.enable;
    };

    # Better "cat"
    bat = {
      enable = true;
    };

    # Devenv "soft" dependency, automatically uses devenv on "cd"
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = programs.zsh.enable;
      enableNushellIntegration = programs.nushell.enable;
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
      enableZshIntegration = programs.zsh.enable;
    };

    # a fast, modern replacement for grep
    ripgrep = {
      enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = programs.zsh.enable;
      enableNushellIntegration = programs.nushell.enable;
      # output of `starship preset pure-preset` converted to nix
      settings = {
        add_newline = true;
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$line_break"
          "$python"
          "$character"
        ];
        directory = {
          style = "blue";
        };
        character = {
          success_symbol = "[λ](purple)";
          error_symbol = "[λ](red)";
          vimcmd_symbol = "[❮](green)";
        };
        git_branch = {
          format = "[$branch]($style)";
          style = "bright-black";
        };
        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
          style = "cyan";
          conflicted = "​";
          untracked = "​";
          modified = "​";
          staged = "​";
          renamed = "​";
          deleted = "​";
          stashed = "≡";
        };
        git_state = {
          format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
          style = "bright-black";
        };
        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };
        python = {
          format = "[$virtualenv]($style) ";
          style = "bright-black";
        };
      };
    };
  };
}
