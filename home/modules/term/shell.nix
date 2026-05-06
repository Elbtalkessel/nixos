{
  lib,
  config,
  pkgs,
  ...
}:
let
  shellAliases =
    let
      Su = "systemctl --user";
      S = "systemctl";
    in
    {
      inherit Su;
      usta = "${Su} start";
      usto = "${Su} stop";
      ures = "${Su} restart";
      ustat = "${Su} status";
      urel = "${Su} daemon-reload";
      ucat = "${Su} cat";
      utimer = "${Su} list-timers";
      usvc = "${Su} --type=service";

      inherit S;
      ssta = "${S} start";
      ssto = "${S} stop";
      sres = "${S} restart";
      sstat = "${S} status";
      srel = "${S} daemon-reload";
      scat = "${S} cat";
      stimer = "${S} list-timers";
      ssvc = "${S} --type=service";

      cp = "cp -iv";
      ln = "ln -v";
      mv = "mv -iv";
      rm = "rm -v";

      sp = lib.getExe pkgs.nix-search-cli;
      vi = lib.getExe pkgs.neovim;
      n = lib.getExe pkgs.neovim;
      g = lib.getExe pkgs.lazygit;
      d = lib.getExe pkgs.lazydocker;
      # For monitoring cached data to permanent storage syncronization progress.
      # Example:
      #   cp a_large_file /run/media/risus/pendrive/
      #   sync
      #   watch dirty
      # Or better use `usbcp` from `usbdrivetools` package.
      dirty = "grep -e Dirty: -e Writeback: /proc/meminfo";
    };
in
{
  programs = rec {
    # file database for nixpkgs
    # usage example: `nix-locate 'bin/hello'`
    nix-index = {
      enable = true;
      # doesn't work at version 0.9.1, fix will be released in version
      # 0.1.10
      # https://github.com/nix-community/nix-index/pull/293
    };

    nushell = {
      enable = true;
      configFile.source = ../../config/nushell/config.nu;
      inherit shellAliases;
    };

    # A POSIX complaint shell for testing things.
    zsh = {
      enable = true;
      dotDir = "${config.home.homeDirectory}/zsh";
      enableCompletion = true;
      shellAliases = shellAliases // {
        ls = "ls --color=auto";
      };
    };

    # Nushell autocomplete
    carapace = {
      inherit (nushell) enable;
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

    starship = {
      enable = true;
      # output of `starship preset pure-preset` converted to nix
      settings = {
        add_newline = true;
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_state"
          "$git_branch"
          "$git_status"
          "$cmd_duration"
          "$line_break"
          "$python"
          "$shell$character"
        ];
        directory = {
          style = "blue";
        };
        git_state = {
          format = ''(\([$state( $progress_current/$progress_total)]($style)\) )'';
          style = "bright-black";
        };
        git_branch = {
          format = "[$branch]($style)";
          style = "bright-black";
        };
        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218)($ahead_behind$stashed)]($style)";
          style = "cyan";
          conflicted = "​";
          untracked = "​";
          modified = "​";
          staged = "​";
          renamed = "​";
          deleted = "​";
          stashed = "≡";
        };
        cmd_duration = {
          format = "( [$duration]($style))";
          style = "yellow";
        };
        # ---
        python = {
          format = "([$virtualenv]($style) )";
          style = "bright-black";
        };
        shell = {
          disabled = false;
          format = "[$indicator]($style)";
          zsh_indicator = "%";
          nu_indicator = "λ";
          unknown_indicator = "$";
          style = "purple";
        };
        character = {
          success_symbol = "[_](purple)";
          error_symbol = "[_](red)";
          vimcmd_symbol = "[_ >](purple)";
        };
      };
    };
  };
}
