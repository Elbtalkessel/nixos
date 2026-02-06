{ pkgs, config, ... }:
let
  preview = pkgs.lib.getExe pkgs.lf-tools.preview;
  mimeo = pkgs.lib.getExe pkgs.mimeo;
  ouch = pkgs.lib.getExe pkgs.ouch;
  tmsu = pkgs.lib.getExe pkgs.tmsu;
in
{
  xdg.configFile = {
    "lf/icons".source = ./icons;
  };
  programs.lf = rec {
    enable = true;

    settings = {
      ratios = [
        # left
        1
        # center
        2
        # right
        3
      ];
      shell = "bash";
      shellopts = "-eu";
      ifs = "\n";
      scrolloff = 10;
      icons = true;
      info = "custom";
      # Show hidden files by default.
      hidden = false;
      # Enable image preview.
      sixel = true;
      # TODO: Implement clearer as part of lf-tools.
      cleaner = "${pkgs.ctpv}/bin/ctpvclear";
    };

    previewer = {
      # TODO: implement wrapper to let previewer only access
      #   what it needs to run, nix wrap, bubblewrap or something else.
      source = pkgs.writeShellScript "previewer.sh" ''
        # ctpv gives pixilated image preview.
        ${preview} "''$1" "''$2" "''$3" "''$4" "''$5"
      '';
    };

    # % - run shell command inside UI.
    # & - run command asynchronously.
    # $ - run command replacing UI.
    commands = {
      # Top-level commands
      # ------------------

      # mimeo instead of xdg-open because works better.
      open = # bash
        ''
          ''${{
            ${mimeo} $f
          }}
        '';

      # TODO: Prefill input with the file's path.
      #   There is no bash / sh tool to do so.
      #   `rlwrap -o -S ">" -P "WHAAT" cat` in terminal, but not in lf.
      #   Maybe I can just before calling `read` start a bg task which
      #     after a delay run `lf -remote` to itself. `send echo "..."` does work, except
      #     it changes prompt, if I could somehow send keypresses...
      # Enhances the builtin rename command checking if specified node exists before renaming.
      rename = # bash
        ''
          %[ -e $1 ] && printf "file exists" || mv $f $1
        '';

      delete = "%gtrash put $fx";

      # Creates a file or directory.
      append = # bash
        ''
          %{{
             set -f
             printf " File name or directory path/ "
             read path
             if [[ $path == */ ]]; then
               mkdir -p $path
             else
               mkdir -p $(dirname $path)
               touch $path
             fi
             lf -remote "send $id select $path"
          }}
        '';

      # Navigate back up to starting directory.
      # You still can leave starting dir by pressing `h`.
      # Runs asynchronously or you will get screen flicker.
      pback = # bash
        ''
          &{{
            if [[ "$PWD" != "$OLDPWD" ]]; then
              lf -remote "send $id updir"
            fi
          }}
        '';

      # f* commands
      # -----------

      # Search and naviagtion is done recursively from a directory where LF has been started (OLDPWD).
      fsearch = # bash
        ''
          ''${{
            set -f
            path=$(fzf --walker-root $OLDPWD --walker-skip=.git,.devenv,.venv)
            lf -remote "send $id select $path"
          }}
        '';

      # Search for a destination and copy to it.
      fcopy = # bash
        ''
          ''${{
            dest="$(fd -t d -c never . $OLDPWD | fzf)" &&
            eval cp -ir $fx $dest
          }}
        '';

      # Search for a destination and move it.
      fmove = # bash
        ''
          ''${{
            dest="$(fd -t d -c never . $OLDPWD | fzf)" &&
            eval mv -i $fx $dest
          }}
        '';

      # a* commands
      # -----------

      aswallpaper = # bash
        ''
          &{{
            ${config.my.wallpaper.cmd.set} $f
          }}
        '';

      # Toggles the preview pane expanded state by changing ratios.
      texpand = # bash
        ''
          &{{
            # I didn't find how to get current ratios value,
            if test -f /tmp/lf.texpanded
            then
              lf -remote "send set ratios ${pkgs.lib.concatStringsSep ":" (map toString settings.ratios)}"
              rm /tmp/lf.texpanded
            else
              lf -remote "send set ratios 1:2:10"
              touch /tmp/lf.texpanded
            fi
          }}
        '';

      # Edit a file using EDITOR.
      # Usually a file can be opened by the opener (xdg-open),
      # but it doesn't always work :(
      edit = # bash
        ''
          ''${{
            $EDITOR $fx
          }}
        '';

      restore = # bash
        ''
          ''${{
            gtrash find\
            | fzf --multi --layout reverse --tac --footer="Restore"\
            | awk -F'\t' '{print $2}'\
            | xargs -I{} gtrash restore '{}'
          }}
        '';

      trash = # bash
        ''
          ''${{
            gtrash find\
            | fzf --multi --layout reverse --tac --footer="Delete Forever"\
            | awk -F'\t' '{print $2}'\
            | xargs -I{} gtrash rm '{}'
          }}
        '';

      tag-add = # bash
        ''
          %{{
          set -f
          tags=$(${tmsu} tags $f)
          if test "$?" -eq 1; then
            echo "Init a tag repository first using the tmsu init command."
          else
            printf "''${tags#*:} "
            read more
            if test -d $f; then
              find $fx -type f | xargs -I{} ${tmsu} tag {} --tags "$more"
            else
              ${tmsu} tag $fx --tags "$more"
            fi
          fi
          }}
        '';

      # Un-archive usin ouch.
      extract = # bash
        ''
          ''${{
            set -f
            if test $(${preview} mime $f major) == "x-archive"; then
              ${ouch} d $f
            fi
          }}
        '';

      compress = # bash
        ''
          ''${{
            set -f
            ${ouch} c $fx "$(basename $(pwd)).tgz"
          }}
        '';
    };

    keybindings = {
      # Unset default to allow f<...> combos.
      f = "";
      # fuzzy search. use / to search in current directory.
      ff = "fsearch";
      "<delete>" = "delete";
      ftr = "restore";
      fte = "trash";
      # cut a file, use `p` to paste it.
      x = "cut";
      # fuzzy copy.
      c = "fcopy";
      # empty-out selection
      e = "clear";
      # fuzzy move.
      m = "fmove";
      # new file, shadows builtin n shortcut.
      n = "append";
      # rename a file
      r = "push :rename<space>";

      # Navigation
      # navigate back up to a starting directory.
      "<backspace2>" = "pback";
      # calls xdg-open.
      "<enter>" = "open";

      # Action
      a = "";
      ax = "texpand";
      aw = "aswallpaper";
      ae = "edit";
      aae = "extract";
      aac = "compress";
      ata = "tag-add";
    };
  };
}
