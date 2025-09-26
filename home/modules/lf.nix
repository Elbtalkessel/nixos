{ pkgs, ... }:
{
  programs.lf = {
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
      previewer = "${pkgs.ctpv}/bin/ctpv";
      cleaner = "${pkgs.ctpv}/bin/ctpvclear";
      shellopts = "-eu";
      ifs = "\n";
      scrolloff = 10;
      icons = true;
      hidden = true;
    };

    # % - run shell command inside UI.
    # & - run command asynchronously.
    # $ - run command replacing UI.
    commands = {
      open = ''
        ''${{
          # inode/x-empty is a file without an extension and with no content
          # for some reason when using zsh EDITOR is set to nano
          case $(file --mime-type $f -b) in
          text/*|application/json|inode/x-empty) nvim $f;;
          esac
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
    };

    keybindings = {
      f = "fsearch";
      # remaps cut from `d` to `x`, easier to remember.
      d = "delete";
      "<delete>" = "delete";
      x = "cut";
      # remaps `c` - clear to fuzzy copy, and sets clear on `e` (bc empty).
      c = "fcopy";
      # clears y (yank) or cut (x) selection.
      e = "clear";
      # m - move a file / directory or a selection to a directory
      m = "fmove";
      # a - append, creates a file or a directory if path ends with slash.
      a = "append";
      "<backspace2>" = "pback";
      r = "push :rename<space>";
      "<enter>" = "open";
    };
  };
}
