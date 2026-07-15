{
  config,
  pkgs,
  lib,
  ...
}:
let
  MAILDIR = "${config.xdg.dataHome}/mail/${config.my.mail.address}";
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
}
