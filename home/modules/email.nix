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
    extraConfig = {
      filters = {
        "text/plain" = "colorize";
        "text/calendar" = "calendar";
        "message/delivery-status" = "colorize";
        "message/rfc822" = "colorize";
        # Much cleaner HTML rendering
        #"text/html" = "${lib.getExe pkgs.lynx} -dump -force_html -stdin | colorize";
        "text/html" = "${lib.getExe pkgs.pandoc} -f html -t plain | colorize";
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

  home.packages = with pkgs; [
    libnotify
  ];

  systemd.user.services.goimapnotify = {
    Unit = {
      Description = "Protonmail Bridge Notifier";
      After = [ "graphical-session.target" ];
    };

    Service =
      let
        secret = config.sops.secrets."protonmail/bridge".path;
      in
      {
        RuntimeDirectory = "goimapnotify";

        ExecStartPre = pkgs.writeShellScript "generate-goimapnotify-config" ''
          set -euo pipefail

          USERNAME="$(${lib.getExe pkgs.yq-go} '.username' ${secret})"
          PASSWORD="$(${lib.getExe pkgs.yq-go} '.password' ${secret})"

          cat > "$RUNTIME_DIRECTORY/config.yaml" <<EOF
          ---
          configurations:
            - host: 127.0.0.1
              port: 1143
              tls: true
              tlsOptions:
                starttls: true
              username: $USERNAME
              password: $PASSWORD
              boxes:
                - mailbox: INBOX
                  onNewMail: notify-send --app-name=aerc --icon=mail-unread "%s" "You've got mail!"
          EOF
        '';

        ExecStart = "${lib.getExe pkgs.goimapnotify} -conf %t/goimapnotify/config.yaml";

        Restart = "always";
        RestartSec = 5;
      };

    Install.WantedBy = [ "default.target" ];
  };
}
