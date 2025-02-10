{ lib, pkgs, ... }:
{
  # Everything related to the shell

  home.packages = with pkgs; [
    # CLI for searching packages on search.nixos.org
    nix-search-cli

    # Network
    curl
    wget
    arp-scan
    httpie

    # Development
    python311Packages.ipython
    lazydocker
    lazygit
    devenv

    # Tools
    ncdu
    translate-shell
    btop
    nvtopPackages.full
    brightnessctl

    # Shell scripts
    (writeShellScriptBin "screen" (builtins.readFile ../bin/screenshot.sh))
    # Reqired from imv.nix for applying a wallpaper
    (writeShellScriptBin "wallpaper" (builtins.readFile ../bin/wallpapper.sh))
  ];

  # Background tasks
  # https://github.com/Nukesor/pueue
  services = {
    pueue = {
      enable = true;
    };
  };

  programs = {
    # file database for nixpkgs
    # usage example: `nix-locate 'bin/hello'`
    nix-index = {
      enable = true;
    };

    nushell = {
      enable = true;
      # for editing directly to config.nu 
      configFile.source = ../config/nushell/config.nu;
      shellAliases = {
        cp = "cp -iv";
        ln = "ln -v";
        mv = "mv -iv";
        rm = "rm -v";
        S = "sudo systemctl";
        s = "sudo";
        Ss = "sudo systemctl status";
        Su = "systemctl --user";
        Sr = "sudo systemctl restart";
        g = "lazygit";
        d = "lazydocker";
        # For monitoring cached data to permanent storage syncronization progress.
        # Example:
        #   cp a_large_file /run/media/risus/pendrive/
        #   sync
        #   watch dirty
        dirty = "grep -e Dirty: -e Writeback: /proc/meminfo";
        bg = "pueue";
      };
    };

    # Nushell autocomplete
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    # "Smarter" cd, tracks visited directories and allows to jump back by typing its name without full path
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
      enableNushellIntegration = true;
    };

    # Devenv "soft" dependency, automatically uses devenv on "cd"
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableNushellIntegration = true;
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

    starship = {
      enable = true;
      enableNushellIntegration = true;
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
