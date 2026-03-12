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

  rnd-wallpaper = pkgs.writeShellScriptBin config.my.wallpaper.cmd.rnd ''
    #!/usr/bin/env bash
    # Picks a random file from given path.
    # Doesn't choose a file twice unless all files has been
    # picked once.
    CLEANUP=false
    SOURCE="${config.my.wallpaper.random.path}"
    DRY_RUN=false
    while [[ $# -gt 0 ]]; do
      case $1 in
        -c|--clean)
          CLEANUP=true
          shift
          ;;
        -s|--source)
          SOURCE="$2"
          shift
          shift
          ;;
        -d|--dry-run)
          DRY_RUN=true
          shift
          ;;
        *)
          echo "Unknown option $1"
          exit 1
          ;;
      esac
    done
    if ! test -d "$SOURCE"; then
      echo "$SOURCE is not a directory"
      exit 1
    fi

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
      flist=$(find "$SOURCE" -type f -name '*.jpg' -or -name '*.png')
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

    # Pick a random file, exit early if the file is missing.
    f=$(echo "$pool" | shuf | head -1)
    echo "$f" >> $USE_FILE
    if ! test -f "$f"; then
      exit 0
    fi

    if ! $DRY_RUN; then
      ${config.my.wallpaper.cmd.set} "$f"
    fi
  '';
in
{
  home.packages = with pkgs; [
    (writeShellScriptBin config.my.wallpaper.cmd.get ''
      #!/usr/bin/env sh
      echo $(dconf dump /org/gnome/desktop/background/ | rg "picture-uri='file://([^']+)'$" -or '$1')
    '')
    (writeShellScriptBin config.my.wallpaper.cmd.set ''
      #!/usr/bin/env sh
      if test -z "$1"; then
        echo "missing wallpaper path" >&2
        exit 1
      fi
      cp -f "$1" $(get-wallpaper)
    '')
    rnd-wallpaper
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
            hyprctl hyprpaper wallpaper ",`${config.my.wallpaper.cmd.get}`"
          '';
          Restart = "on-failure";
          RestartSec = 2;
          TimeoutStopSec = 10;
        };
      };
      rnd-wallpaper = lib.mkIf (config.my.wallpaper.random.path != "") {
        inherit Install;
        Unit = Unit {
          Description = "sets a random wallpaper";
        };
        Service = {
          Type = "oneshot";
          ExecStart = lib.getExe rnd-wallpaper;
          Restart = "on-failure";
          RestartSec = 2;
          TimeoutStopSec = 10;
        };
      };
    };
    # ---

    # timers
    timers = {
      rnd-wallpaper =
        lib.mkIf (config.my.wallpaper.random.timer != "" && config.my.wallpaper.random.path != "")
          {
            inherit Install;
            Unit = Unit {
              Description = "Sets a random wallpaper periodically";
            };
            Timer = {
              OnBootSec = "5s";
              OnUnitActiveSec = config.my.wallpaper.random.timer;
              Unit = "rnd-wallpaper";
            };
          };
    };
    # ---

  };
}
