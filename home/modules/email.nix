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
  programs.aerc = {
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

  services.protonmail-bridge = {
    enable = true;
  };

  services.mbsync = {
    enable = true;
    frequency = "*:0/5";
    configFile = "${config.xdg.configHome}/mbsync/mbsyncrc";
    preExec = "${lib.getExe' pkgs.coreutils "mkdir"} -p ${MAILDIR}";
  };

  xdg.configFile."mbsync/mbsyncrc".text = ''
    IMAPAccount default
    Host ${config.my.mail.host}
    Port ${config.my.mail.port}
    User "${config.my.mail.address}"
    PassCmd "${lib.getExe pkgs.libsecret} lookup ${config.my.mail.password}"
    SSLType ${config.my.mail.sslType}

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
    Patterns *
    Sync Full
    Create Both
    Remove Both
    Expunge Both
    SyncState *
  '';

  #systemd.user.timers.mbsync  = {
  #  Unit.Description = "Periodic Proton mail sync";
  #  Timer = {
  #    OnBootSec = "2min";
  #    OnUnitActiveSec = "5min";
  #  };
  #  Install.WantedBy = [
  #    "timers.target"
  #  ];
  #};
  #systemd.user.services.mbsync = {
  #   Unit = {
  #     Description = "Sync Proton Mail";
  #     After = [ "protonmail-bridge.service" ];
  #   };
  #   Service = {
  #     ExecStart = "${pkgs.isync}/bin/mbsync -c ${config.sops.templates."mbsyncrc".path} protonmail";
  #   };
  #};

  systemd.user.services = {
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
}
