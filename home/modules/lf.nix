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

      # Enhances the builtin rename command checking if specified node exists before renaming.
      rename = ''
        %[ -e $1 ] && printf "file exists" || mv $f $1
      '';

      extract = ''
        ''${{
          set -f
          case $f in
          *.tgz | *.tar | *.zip | *.7z | *.gz | *.xz | *.lzma | *.bz | *.bz2 | *.bz3 | *.lz4 | *.sz | *.zst | *.rar | *.br) ouch d $f;;
          esac
        }}
      '';

      # Fuzzy file search. Default is builtin find command, but I don't find it useful :)
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

      fmove = ''
        ''${{
          dest="$(fd -t d -c never . $OLDPWD | fzf)" &&
          eval mv -i $fx $dest
        }}
      '';

      # % - run shell command inside UI.
      append = ''
        %{{
           set -f
           printf " file name or directory path/: "
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
      # & - run command asynchronously, or you will get screen flicker.
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
