{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.protonmail-bridge = {
    enable = true;
    extraPackages = with pkgs; [ gnome-keyring ];
  };

  programs.aerc = {
    enable = true;
    extraAccounts = {
      Personal = {
        source = "maildir://~/.mail/protonmail";
        default = "INBOX";
        from = "Yan Kim <rtfsc@pm.me>";
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

  sops.templates."mbsyncrc".content = ''
    IMAPAccount protonmail
    Host 127.0.0.1
    Port 1143
    User ${config.sops.placeholder."protonmail.bridge.username"}
    Pass ${config.sops.placeholder."protonmail.bridge.password"}
    SSLType STARTTLS

    IMAPStore protonmail-remote
    Account protonmail

    MaildirStore protonmail-local
    Path ~/.mail/protonmail/
    Inbox ~/.mail/protonmail/INBOX
    Subfolders Verbatim

    Channel protonmail
    Far :protonmail-remote:
    Near :protonmail-local:
    Patterns *
    Create Both
    SyncState *
  '';

  systemd.user.services = {
    mbsync = {
      Unit = {
        Description = "Sync Proton Mail";
        After = [ "protonmail-bridge.service" ];
      };
      Service = {
        ExecStart = "${pkgs.isync}/bin/mbsync -c ${config.sops.templates."mbsyncrc".path} protonmail";
      };
    };

    mail-notify = {
      Unit.Description = "Mail notifications";
      Service = {
        ExecStart =
          pkgs.writeShellScript "mail-notify" # bash
            ''
              #!/usr/bin/env bash
              ${pkgs.inotify-tools}/bin/inotifywait \
                -m \
                -e create \
                ~/.mail/protonmail/INBOX/new |
              while read; do
                ${pkgs.libnotify}/bin/notify-send \
                  --app-name=aerc \
                  "New mail" \
                  "You have new mail"
              done
            '';
        Restart = "always";
      };
      Install.WantedBy = [
        "default.target"
      ];
    };
  };

  systemd.user.timers = {
    mbsync = {
      Unit.Description = "Periodic Proton mail sync";
      Timer = {
        OnBootSec = "2min";
        OnUnitActiveSec = "5min";
      };
      Install.WantedBy = [
        "timers.target"
      ];
    };
  };
}
