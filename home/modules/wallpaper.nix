{
  config,
  pkgs,
  lib,
  ...
}:
let
  Unit =
    override:
    (
      {
        After = [ "hyprpaper.service" ];
        Wants = [ "hyprpaper.service" ];
      }
      // override
    );

  Install = {
    WantedBy = [ "hyprland-session.target" ];
  };

  set-wallpaper = pkgs.writeShellScriptBin config.my.wallpaper.cmd.set ''
    #!/usr/bin/env bash
    # Copies a source to the wallpaper file triggering filewatcher to actually set wallpaper.
    # In case of a directory, will select a random image file from it.
    # Calling without arguments will select another wallpaper from the directory (if default source is directory.)
    # Otherwise will do nothing.

    CLEANUP=false
    SOURCE="${config.my.wallpaper.source}"
    DEST="${config.my.wallpaper.path}"

    while [[ $# -gt 0 ]]; do
      case $1 in
        # Only valid for directory source, cleanup current wallpaper list to select from.
        -c|--clean)
          CLEANUP=true
          shift
          ;;
        # Path to a wallpaper or directory containing JPGs or PNGs.
        -s|--source)
          SOURCE="$2"
          shift
          shift
          ;;
        -d|--dest)
          DEST="$2"
          shift
          shift
          ;;
        *)
          echo "Unknown option $1"
          exit 1
          ;;
      esac
    done

    if test "$DEST" == ""; then
      echo "--dest (-d) flag is required."
      exit 1
    fi

    if test "$SOURCE" == ""; then
      echo "--source (-s) flag is required."
      exit 1
    fi

    try-write-wallpaper() {
      if test -f "$1"; then
        cp -f "$1" "$DEST"
        exit 0
      fi
    }

    # Function will exit if source is a file.
    try-write-wallpaper "$SOURCE"

    CACHE_FILE=/tmp/random-wallpaper-list
    USE_FILE=/tmp/random-wallpaper-used

    if $CLEANUP; then
      rm /tmp/random-wallpaper-{list,used}
    fi
    touch $CACHE_FILE $USE_FILE

    # Populate empty cache.
    # Note: calling script twice using different -s will result
    # in using cache from the first run. This is intentional,
    # to reset it, use `-c` option.
    if ! test -s $CACHE_FILE; then
      if ! test -d "$SOURCE"; then
        echo "$SOURCE is not a directory"
        exit 1
      fi

      flist=$(find "$SOURCE" -name '*.jpg' -or -name '*.png')
      if test -z "$flist"; then
        echo "$SOURCE directory doesn't contain any *.jpg or *.png"
        exit 0
      fi
      echo "$flist" > $CACHE_FILE
    fi

    # List of used files and a pool of files to choice from.
    # Empty pool means USE_FILE == CACHE_FILE, in such case,
    # empty the USE_FILE and use CACHE_FILE content as the pool value.
    pool=$(comm -2 -3 <(sort $CACHE_FILE) <(sort $USE_FILE))
    if test -z "$pool"; then
      echo "" > $USE_FILE
      pool=$(<$CACHE_FILE)
    fi

    f=$(echo "$pool" | shuf | head -1)
    echo "$f" >> $USE_FILE

    try-write-wallpaper "$f"
  '';
in
{
  home.packages = [
    set-wallpaper
  ];

  systemd.user = {
    # paths
    paths = {
      wallpaper = {
        inherit Install;
        Unit = Unit {
          Description = "wallpaper file watcher";
        };
        Path = {
          PathChanged = config.my.wallpaper.path;
          Unit = "wallpaper.service";
        };
      };
    };
    # ---

    # services
    services = {
      wallpaper = {
        inherit Install;
        Unit = Unit {
          Description = "wallpaper setter";
        };
        Service = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "apply-wallpaper" ''
            #!/usr/bin/env sh
            hyprctl hyprpaper wallpaper ",${config.my.wallpaper.path}"
          '';
          Restart = "on-failure";
          RestartSec = 2;
          TimeoutStopSec = 10;
        };
      };
      random-wallpaper = lib.mkIf config.my.wallpaper.random.enable {
        inherit Install;
        Unit = Unit {
          Description = "sets a random wallpaper";
        };
        Service = {
          Type = "oneshot";
          ExecStart = lib.getExe set-wallpaper;
          Restart = "on-failure";
          RestartSec = 2;
          TimeoutStopSec = 10;
        };
      };
    };
    # ---

    # timers
    timers = {
      # Doesn't set wallpaper by itself,
      # triggers the `random-wallpaper` service, in turn it will write a
      # random wallpaper into path the `get-wallpaper` command returns,
      # this triggers file watcher that triggers the `wallpaper` service.
      random-wallpaper = lib.mkIf config.my.wallpaper.random.enable {
        inherit Install;
        Unit = Unit {
          Description = "Sets a random wallpaper periodically";
        };
        Timer = {
          OnBootSec = "5s";
          OnUnitActiveSec = config.my.wallpaper.random.timer;
          Unit = "random-wallpaper";
        };
      };
    };
    # ---

  };
}
