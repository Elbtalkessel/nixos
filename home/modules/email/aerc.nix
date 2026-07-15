{
  config,
  pkgs,
  lib,
  ...
}:
let
  MAILDIR = "${config.xdg.dataHome}/mail/${config.my.mail.address}";
  html2txt = "${lib.getExe pkgs.lynx} -dump -stdin -force_html -assume_local_charset=UTF-8 -display_charset=UTF-8";
  copyCmd = lib.getExe' pkgs.wl-clipboard "wl-copy";
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
        "text/html" = "${html2txt} | colorize";
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
    # Extra binds my ass, it overrides existing 😤
    extraBinds = {
      "global" = {
        "<C-p>" = ":prev-tab<Enter>";
        "<C-PgUp>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
        "<C-PgDn>" = ":next-tab<Enter>";
        "\\[t" = ":prev-tab<Enter>";
        "\\]t" = ":next-tab<Enter>";
        "<C-t>" = ":term<Enter>";
        "?" = ":help keys<Enter>";
        "<C-c>" = ":prompt 'Quit?' quit<Enter>";
        "<C-q>" = ":prompt 'Quit?' quit<Enter>";
        "<C-z>" = ":suspend<Enter>";
      };
      "messages" = {
        "q" = ":prompt 'Quit?' quit<Enter>";
        "j" = ":next<Enter>";
        "<Down>" = ":next<Enter>";
        "<C-d>" = ":next 50%<Enter>";
        "<C-f>" = ":next 100%<Enter>";
        "<PgDn>" = ":next 100%<Enter>";
        "k" = ":prev<Enter>";
        "<Up>" = ":prev<Enter>";
        "<C-u>" = ":prev 50%<Enter>";
        "<C-b>" = ":prev 100%<Enter>";
        "<PgUp>" = ":prev 100%<Enter>";
        "g" = ":select 0<Enter>";
        "G" = ":select -1<Enter>";
        "J" = ":next-folder<Enter>";
        "<C-Down>" = ":next-folder<Enter>";
        "K" = ":prev-folder<Enter>";
        "<C-Up>" = ":prev-folder<Enter>";
        "H" = ":collapse-folder<Enter>";
        "<C-Left>" = ":collapse-folder<Enter>";
        "L" = ":expand-folder<Enter>";
        "<C-Right>" = ":expand-folder<Enter>";
        "v" = ":mark -t<Enter>";
        "<Space>" = ":mark -t<Enter>:next<Enter>";
        "V" = ":mark -v<Enter>";
        "T" = ":toggle-threads<Enter>";
        "zc" = ":fold<Enter>";
        "zo" = ":unfold<Enter>";
        "za" = ":fold -t<Enter>";
        "zM" = ":fold -a<Enter>";
        "zR" = ":unfold -a<Enter>";
        "<tab>" = ":fold -t<Enter>";
        "zz" = ":align center<Enter>";
        "zt" = ":align top<Enter>";
        "zb" = ":align bottom<Enter>";
        "<Enter>" = ":view<Enter>";
        "d" = ":choose -o y 'Really delete this message' delete-message<Enter>";
        "D" = ":delete<Enter>";
        "a" = ":archive flat<Enter>";
        "A" = ":unmark -a<Enter>:mark -T<Enter>:archive flat<Enter>";
        "C" = ":compose<Enter>";
        "m" = ":compose<Enter>";
        "b" = ":bounce<space>";
        "rr" = ":reply -a<Enter>";
        "rq" = ":reply -aq<Enter>";
        "Rr" = ":reply<Enter>";
        "Rq" = ":reply -q<Enter>";
        "c" = ":cf<space>";
        "$" = ":term<space>";
        "!" = ":term<space>";
        "|" = ":pipe<space>";
        "/" = ":search<space>";
        "\\" = ":filter<space>";
        "n" = ":next-result<Enter>";
        "N" = ":prev-result<Enter>";
        "<Esc>" = ":clear<Enter>";
        "s" = ":split<Enter>";
        "S" = ":vsplit<Enter>";
        "pl" = ":patch list<Enter>";
        "pa" = ":patch apply <Tab>";
        "pd" = ":patch drop <Tab>";
        "pb" = ":patch rebase<Enter>";
        "pt" = ":patch term<Enter>";
        "ps" = ":patch switch <Tab>";
      };
      "messages:folder=Drafts" = {
        "<Enter>" = ":recall<Enter>";
      };
      "view" = {
        "/" = ":toggle-key-passthrough<Enter>/";
        "q" = ":close<Enter>";
        "O" = ":open<Enter>";
        "o" = ":open<Enter>";
        "S" = ":save<space>";
        "|" = ":pipe<space>";
        "D" = ":delete<Enter>";
        "A" = ":archive flat<Enter>";

        "<C-y>" = ":copy-link <space>";
        "<C-l>" = ":open-link <space>";

        "f" = ":forward<Enter>";
        "rr" = ":reply -a<Enter>";
        "rq" = ":reply -aq<Enter>";
        "Rr" = ":reply<Enter>";
        "Rq" = ":reply -q<Enter>";

        "H" = ":toggle-headers<Enter>";
        "<C-k>" = ":prev-part<Enter>";
        "<C-Up>" = ":prev-part<Enter>";
        "<C-j>" = ":next-part<Enter>";
        "<C-Down>" = ":next-part<Enter>";
        "J" = ":next<Enter>";
        "<C-Right>" = ":next<Enter>";
        "K" = ":prev<Enter>";
        "<C-Left>" = ":prev<Enter>";
        "yy" = ":pipe -b -s -p ${html2txt} | ${copyCmd}<Enter>";
      };
      "view::passthrough" = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "<Esc>" = ":toggle-key-passthrough<Enter>";
      };
      "compose" = {
        # Keybindings used when the embedded terminal is not selected in the compose
        # view
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "$complete" = "<C-o>";
        "<C-k>" = ":prev-field<Enter>";
        "<C-Up>" = ":prev-field<Enter>";
        "<C-j>" = ":next-field<Enter>";
        "<C-Down>" = ":next-field<Enter>";
        "<A-p>" = ":switch-account -p<Enter>";
        "<C-Left>" = ":switch-account -p<Enter>";
        "<A-n>" = ":switch-account -n<Enter>";
        "<C-Right>" = ":switch-account -n<Enter>";
        "<tab>" = ":next-field<Enter>";
        "<backtab>" = ":prev-field<Enter>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-PgUp>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
        "<C-PgDn>" = ":next-tab<Enter>";
      };
      "compose::editor" = {
        # Keybindings used when the embedded terminal is selected in the compose view
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "<C-k>" = ":prev-field<Enter>";
        "<C-Up>" = ":prev-field<Enter>";
        "<C-j>" = ":next-field<Enter>";
        "<C-Down>" = ":next-field<Enter>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-PgUp>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
        "<C-PgDn>" = ":next-tab<Enter>";
      };
      "compose::review" = {
        # Keybindings used when reviewing a message to be sent
        # Inline comments are used as descriptions on the review screen
        "y" = ":send<Enter> # Send";
        "n" = ":abort<Enter> # Abort (discard message, no confirmation)";
        "s" = ":sign<Enter> # Toggle signing";
        "x" = ":encrypt<Enter> # Toggle encryption to all recipients";
        "v" = ":preview<Enter> # Preview message";
        "p" = ":postpone<Enter> # Postpone";
        "q" = ":choose -o d discard abort -o p postpone postpone<Enter> # Abort or postpone";
        "e" = ":edit<Enter> # Edit (body and headers)";
        "a" = ":attach<space> # Add attachment";
        "d" = ":detach<space> # Remove attachment";
      };
      "terminal" = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
        "<C-PgUp>" = ":prev-tab<Enter>";
        "<C-PgDn>" = ":next-tab<Enter>";
      };
    };
  };
}
