{ pkgs, lib, ... }:
let
  # TBD
  # --- Configuration surface -------------------------------------------------
  # Enable the volume ducking daemon.
  enable = true;
  # MPD stream volume while ducked (fractional PipeWire volume accepted by wpctl).
  duckLevel = "0.30";
  # Application name of the stream to duck.
  targetAppName = "mpd";
  # Application name of the stream that triggers ducking.
  triggerAppName = "mpv";
  # Delay (milliseconds) before reconciling after an observed event.
  debounceMs = 250;
  # Extra logging to the user journal.
  debug = true;

  # --- Tool paths ------------------------------------------------------------
  wpctl = lib.getExe pkgs.wireplumber;
  pwDump = lib.getExe' pkgs.pipewire "pw-dump";
  pwMon = lib.getExe' pkgs.pipewire "pw-mon";
  jq = lib.getExe pkgs.jq;

  duckAudioScript = pkgs.writeShellScriptBin "duck-audio" ''
    set -uo pipefail

    export PATH="${
      lib.makeBinPath [
        pkgs.wireplumber
        pkgs.pipewire
        pkgs.jq
        pkgs.coreutils
        pkgs.gnugrep
        pkgs.gawk
        pkgs.procps
      ]
    }:$PATH"

    # --- Static configuration (substituted by Nix at build time) -------------
    DUCK_LEVEL="${duckLevel}"
    TARGET_APP="${targetAppName}"
    TRIGGER_APP="${triggerAppName}"
    DEBOUNCE_MS="${toString debounceMs}"
    DEBUG="${if debug then "1" else "0"}"

    WPCTL="${wpctl}"
    PW_DUMP="${pwDump}"
    PW_MON="${pwMon}"
    JQ="${jq}"

    # --- Runtime state -------------------------------------------------------
    RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/tmp}/duck-audio"
    LOCK_FILE="$RUNTIME_DIR/lock"
    STATE_DIR="$RUNTIME_DIR/state"

    log() {
      echo "duck-audio: $*"
    }

    dbg() {
      if [ "$DEBUG" = "1" ]; then
        echo "duck-audio[debug]: $*"
      fi
    }

    # --- Lock ----------------------------------------------------------------
    acquire_lock() {
      mkdir -p "$RUNTIME_DIR" "$STATE_DIR"
      exec 9>"$LOCK_FILE"
      if ! flock -n 9; then
        log "another instance already holds the lock, exiting"
        exit 1
      fi
      # Discard stale saved state left over from a prior crashed process.
      rm -f "$STATE_DIR"/* 2>/dev/null || true
      dbg "lock acquired, stale state cleared"
    }

    # --- Audio stack readiness -----------------------------------------------
    #wait_for_audio_stack() {
    #  until "$WPCTL" status >/dev/null 2>&1; do
    #    log "waiting for pipewire"
    #    sleep 1
    #  done
    #  dbg "audio stack is available"
    #}

    # --- Stream enumeration --------------------------------------------------
    # Emit "<node-id> <app-name>" lines for playback (output) audio streams.
    scan_streams() {
      "$PW_DUMP" 2>/dev/null | "$JQ" -r '
        .[]
        | select(.type == "PipeWire:Interface:Node")
        | select(.info.props["media.class"] == "Stream/Output/Audio")
        | "\(.id) \(.info.props["application.name"] // "")"
      ' 2>/dev/null || true
    }

    # Print node ids whose application name matches $1 (case-insensitive substring).
    match_nodes() {
      local want="$1"
      scan_streams | while read -r id app; do
        [ -n "$id" ] || continue
        local app_lc want_lc
        app_lc="$(printf '%s' "$app" | tr '[:upper:]' '[:lower:]')"
        want_lc="$(printf '%s' "$want" | tr '[:upper:]' '[:lower:]')"
        case "$app_lc" in
          *"$want_lc"*) echo "$id" ;;
        esac
      done
    }

    # --- Volume helpers ------------------------------------------------------
    get_volume() {
      local id="$1" out
      out="$("$WPCTL" get-volume "$id" 2>/dev/null)" || return 1
      # Output looks like: "Volume: 0.74" or "Volume: 0.74 [MUTED]".
      echo "$out" | awk '{print $2}'
    }

    set_volume() {
      local id="$1" value="$2"
      "$WPCTL" set-volume "$id" "$value" 2>/dev/null
    }

    # --- Duck / restore ------------------------------------------------------
    duck_mpd() {
      local id="$1" state_file="$STATE_DIR/$id" orig
      if [ ! -f "$state_file" ]; then
        orig="$(get_volume "$id")"
        if [ -z "$orig" ]; then
          log "volume read failed for target id=$id, skipping duck"
          return 0
        fi
        echo "$orig" >"$state_file"
        log "ducking target id=$id old=$orig new=$DUCK_LEVEL"
      else
        orig="$(cat "$state_file")"
        dbg "target id=$id already ducked (saved orig=$orig)"
      fi
      set_volume "$id" "$DUCK_LEVEL"
    }

    restore_mpd() {
      local id="$1" state_file="$STATE_DIR/$id" orig
      [ -f "$state_file" ] || return 0
      orig="$(cat "$state_file")"
      if set_volume "$id" "$orig"; then
        log "restoring target id=$id volume=$orig"
      else
        log "target disappeared before restore id=$id"
      fi
      rm -f "$state_file"
    }

    # --- Reconciliation ------------------------------------------------------
    reconcile_state() {
      local target_ids trigger_ids trigger_count
      target_ids="$(match_nodes "$TARGET_APP")"
      trigger_ids="$(match_nodes "$TRIGGER_APP")"

      trigger_count=0
      if [ -n "$trigger_ids" ]; then
        trigger_count="$(printf '%s\n' "$trigger_ids" | grep -c . || true)"
      fi

      # Drop saved state for target nodes that no longer exist.
      for state_file in "$STATE_DIR"/*; do
        [ -e "$state_file" ] || continue
        local sid
        sid="$(basename "$state_file")"
        if ! printf '%s\n' "$target_ids" | grep -qx "$sid"; then
          dbg "target id=$sid gone while ducked, discarding saved state"
          rm -f "$state_file"
        fi
      done

      if [ "$trigger_count" -gt 0 ] && [ -n "$target_ids" ]; then
        log "active_triggers=$trigger_count state=ducked"
        while read -r id; do
          [ -n "$id" ] || continue
          duck_mpd "$id"
        done <<<"$target_ids"
      else
        while read -r id; do
          [ -n "$id" ] || continue
          restore_mpd "$id"
        done <<<"$target_ids"
        dbg "active_triggers=$trigger_count state=unducked"
      fi
    }

    # --- Main loop -----------------------------------------------------------
    main_loop() {
      # Initial full reconcile before subscribing to ongoing events.
      reconcile_state

      local debounce_s
      debounce_s="$(awk "BEGIN { printf \"%.3f\", $DEBOUNCE_MS / 1000 }")"

      # React to graph changes reported by the monitor. If the monitor
      # subprocess exits, the read loop ends and we exit nonzero so systemd
      # restarts the service.
      "$PW_MON" 2>/dev/null | while read -r _line; do
        sleep "$debounce_s"
        # Drain any events that queued up during the debounce window.
        reconcile_state
      done

      log "monitor exited unexpectedly"
      return 1
    }

    trap 'log "received termination signal, exiting"; exit 0' TERM INT

    acquire_lock
    main_loop
    exit 1
  '';
in
lib.mkIf enable {
  home.packages = [ duckAudioScript ];

  systemd.user.services.duck-audio = {
    Unit = {
      Description = "Duck MPD volume while mpv is playing";
      After = [
        "pipewire.service"
        "wireplumber.service"
      ];
      Wants = [
        "pipewire.service"
        "wireplumber.service"
      ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${duckAudioScript}/bin/duck-audio";
      Restart = "on-failure";
      RestartSec = "2s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
