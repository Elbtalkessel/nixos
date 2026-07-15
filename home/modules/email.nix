{
  pkgs,
  config,
  lib,
  ...
}:
let
  MAILDIR = "${config.xdg.dataHome}/mail/${config.my.mail.address}";
  INBOX = "${MAILDIR}/INBOX";
in
{
  programs = {
    aerc = {
      enable = true;
      extraAccounts = {
        Default = {
          source = "maildir://${MAILDIR}";
          default = "INBOX";
          from = "${config.my.username} <${config.my.mail.address}>";
          cache-headers = true;
          copy-to = "Sent";
          default-trash = "Trash";
          default-sent = "Sent";
          default-drafts = "Drafts";
        };
      };
      extraConfig = {
        general = {
          unsafe-accounts-conf = true;
        };
        filters = {
          "text/plain" = "colorize";
          "text/calendar" = "calendar";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
          # Much cleaner HTML rendering
          "text/html" =
            "${lib.getExe pkgs.lynx} -dump -stdin -force_html -assume_local_charset=UTF-8 -display_charset=UTF-8 | colorize";
          #"text/html" = "${lib.getExe pkgs.pandoc} -f html -t plain | colorize";
        };
        ui = {
          threading-enabled = true;
          threading-by-subject = true;
          sort-thread-siblings = true;
          sort = "-r date";
          timestamp-format = "2006-01-02";
          this-day-time-format = "15:04";
          this-week-time-format = "Mon 15:04";
          this-year-time-format = "Jan 02";
          index-columns = "flags:4,name<20%,subject,date>12";
          fuzzy-complete = true;
          border-char-vertical = "│";
          border-char-horizontal = "─";
          styleset-name = "catppuccin-mocha";
          dirlist-right = "{{if .Unread}}{{humanReadable .Unread}}{{end}}";
        };
        viewer = {
          pager = "less -FRX";
        };
        openers = {
          "x-scheme-handler/http*" = "xdg-open {}";
          "x-scheme-handler/mailto" = "xdg-open {}";
        };
      };
    };
    notmuch = {
      enable = true;
      new = {
        tags = [
          "unread"
          "inbox"
        ];
        ignore = [
          ".mbsyncstate"
          ".uidvalidity"
          ".mbsyncstate.journal"
        ];
      };
      hooks = {
        preNew = "";
        # Tags all standard directories plus based
        # on Folders|Labels subdirectories creates additional tags
        # and tags these directories with it.
        # Note for the consistency sake all tags are lowercased,
        # commans replaces with whitespace, multiple whitespaces squezed into
        # single plus sign and result is trimmed.
        postNew =
          # bash
          ''
            notmuch tag +archive -- folder:Archive
            notmuch tag +draft -- folder:Drafts
            notmuch tag +sent -- folder:Sent
            notmuch tag +spam -- folder:Spam
            notmuch tag +starred -- folder:Starred
            notmuch tag +trash -- folder:Trash
            # Remove inbox tag from everything outside INBOX
            notmuch tag -inbox -- not folder:INBOX

            # Dynamic tags based on labels
            while read -r dir; do
              label="''${dir##*/}"
              parent="''${''${dir%/*}##*/}"
              # lowercase, replace all punctuation and whitespace by single + sign.
              tag=$(printf '%s' "$label" | tr '[:upper:]' '[:lower:]' | tr ',' ' ' | xargs | tr -s ' ' '+')
              notmuch tag +"$tag" -- folder:"$parent/$label"
            done < <(find "${MAILDIR}/Labels" "${MAILDIR}/Folders" -mindepth 1 -maxdepth 1 -type d -not -name "All")
          '';
      };
      maildir = {
        synchronizeFlags = true;
      };
      extraConfig = {
        database = {
          path = MAILDIR;
        };
        user = {
          name = config.my.username;
          primary_email = config.my.mail.address;
        };
        new = {
          tags = "unread;inbox";
          ignore = ".mbsyncstate;.uidvalidity";
        };
        search = {
          exclude_tags = "deleted;spam;trash;";
        };
      };
    };
    mbsync = {
      enable = true;
      extraConfig = ''
        IMAPAccount default
        Host ${config.my.mail.host}
        Port ${config.my.mail.port}
        User "${config.my.mail.address}"
        PassCmd "${lib.getExe pkgs.libsecret} lookup ${config.my.mail.password}"
        TLSType ${config.my.mail.sslType}

        IMAPStore default-remote
        Account default

        MaildirStore default-local
        # trailing slash is required
        Path ${MAILDIR}/
        Inbox ${INBOX}
        Subfolders Verbatim
        MaxSize 100M

        Channel default
        Far :default-remote:
        Near :default-local:
        # Don't sync virtual all mail directory
        # https://github.com/ProtonMail/gluon/issues/426
        Patterns * !"All Mail" !"Starred"
        Sync Full
        # Preserve original arrival timestamps across syncs
        CopyArrivalDate yes
        # Create and remove mailboxes on server only,
        # propagate change from server to client.
        Create Near
        Remove Near
        Expunge Both
        SyncState *
      '';
    };
  };

  services = {
    mbsync = {
      enable = true;
      frequency = "*:0/5";
      # https://mynixos.com/home-manager/option/services.mbsync.configFile
      # Says it defaults to ~/.mbsyncrc
      # However mbsync man page state that it checks .config/isyncrc
      # programs.mbsync write config to .config/isyncrc
      configFile = "${config.xdg.configHome}/isyncrc";
      preExec = "${lib.getExe' pkgs.coreutils "mkdir"} -p ${MAILDIR}";
    };
    protonmail-bridge = {
      enable = true;
    };
  };
  systemd.user = {
    timers = {
      notmuch-new = {
        Unit.Description = "Update notmuch database";
        Timer = {
          OnBootSec = "2min";
          OnUnitActiveSec = "5min";
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
    services = {
      notmuch-new = {
        Unit.Description = "Update notmuch database";
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.notmuch}/bin/notmuch new";
        };
      };
      mail-notify = {
        Unit.Description = "Mail notifications";
        Service = {
          ExecStart =
            pkgs.writeShellScript "mail-notify" # bash
              ''
                #!/usr/bin/env bash
                ${pkgs.inotify-tools}/bin/inotifywait -m -e create ${INBOX}/new | while read; do
                  ${pkgs.libnotify}/bin/notify-send --app-name=aerc "New mail" "You have new mail"
                done
              '';
          Restart = "always";
        };
        Install.WantedBy = [
          "default.target"
        ];
      };
    };
  };
}
