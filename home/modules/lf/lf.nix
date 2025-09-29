{ pkgs, ... }:
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
      sortby = "time";
      info = "time";
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
        ${pkgs.lib.getExe pkgs.lf-tools.preview} "''$1" "''$2" "''$3" "''$4" "''$5"
      '';
    };

    # % - run shell command inside UI.
    # & - run command asynchronously.
    # $ - run command replacing UI.
    commands = {
      open = ''
        ''${{
          xdg-open $f
        }}
      '';

      # TODO: Prefill input with the file's path.
      #   There is no bash / sh tool to do so.
      #   `rlwrap -o -S ">" -P "WHAAT" cat` in terminal, but not in lf.
      #   Maybe I can just before calling `read` start a bg task which
      #     after a delay run `lf -remote` to itself. `send echo "..."` does work, except
      #     it changes prompt, if I could somehow send keypresses...
      # Enhances the builtin rename command checking if specified node exists before renaming.
      rename = ''
        %[ -e $1 ] && printf "file exists" || mv $f $1
      '';

      # Un-archive usin ouch.
      extract = ''
        ''${{
          set -f
          case $f in
          *.tgz | *.tar | *.zip | *.7z | *.gz | *.xz | *.lzma | *.bz | *.bz2 | *.bz3 | *.lz4 | *.sz | *.zst | *.rar | *.br) ${pkgs.lib.getExe pkgs.ouch} d $f;;
          esac
        }}
      '';

      # File search.
      # Search and naviagtion is done recursively from a directory where LF has been started (OLDPWD).
      fsearch = ''
        ''${{
          set -f
          path=$(fzf --walker-root $OLDPWD --walker-skip=.git,.devenv,.venv)
          lf -remote "send $id select $path"
        }}
      '';

      # Search for a destination and copy to it.
      fcopy = ''
        ''${{
          dest="$(fd -t d -c never . $OLDPWD | fzf)" &&
          eval cp -ir $fx $dest
        }}
      '';

      # Search for a destination and move it.
      fmove = ''
        ''${{
          dest="$(fd -t d -c never . $OLDPWD | fzf)" &&
          eval mv -i $fx $dest
        }}
      '';

      # Creates a file or directory.
      append = ''
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
      pback = ''
        &{{
          if [[ "$PWD" != "$OLDPWD" ]]; then
            lf -remote "send $id updir"
          fi
        }}
      '';

      aswallpaper = ''
        &{{
          setbg $f
        }}
      '';

      # Toggles the preview pane expanded state by changing ratios.
      texpand = ''
        &{{
          # I didn't find how to get current ratios value,
          if test -f /tmp/lf.texpanded
          then
            lf -remote "send set ratios ${pkgs.lib.concatStringsSep ":" (map builtins.toString settings.ratios)}"
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
      edit = ''
        ''${{
          $EDITOR $fx
        }}
      '';

      waifu = ''
        &{{
          waifu -n true -l true
        }}
      '';

      delete = ''%gtrash put $fx'';

      restore = ''
        ''${{
          gtrash find\
          | fzf --multi --layout reverse --tac --footer="Restore"\
          | awk -F'\t' '{print $2}'\
          | xargs -I{} gtrash restore '{}'
        }}
      '';

      delete-forever = ''
        ''${{
          gtrash find\
          | fzf --multi --layout reverse --tac --footer="Delete Forever"\
          | awk -F'\t' '{print $2}'\
          | xargs -I{} gtrash rm '{}'
        }}
      '';
    };

    keybindings = {
      # File(s) operations
      # fuzzy search. use / to search in current directory.
      ff = "fsearch";
      # remaps cut from `d` to `x`, easier to remember.
      fdd = "delete";
      "<delete>" = "delete";
      fdr = "restore";
      fde = "delete-forever";
      # cut a file, use `p` to paste it.
      fx = "cut";
      # fuzzy copy.
      fc = "fcopy";
      # empty-out selection
      fe = "clear";
      # fuzzy move.
      fm = "fmove";
      # a - append, creates a file or a directory if path ends with slash.
      fa = "append";
      # rename a file
      fr = "push :rename<space>";
      # disable default renaming.
      r = "";
      f = "";

      # Navigation
      # navigate back up to a starting directory.
      "<backspace2>" = "pback";
      # calls xdg-open.
      "<enter>" = "open";

      # Action
      ax = "texpand";
      aw = "aswallpaper";
      ae = "edit";
      ad = "waifu";
    };
  };
}
