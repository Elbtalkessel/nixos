{ config, ... }:
{
  xdg = {
    mimeApps = {
      enable = true;
      # Prefer using mimeo (https://xyne.dev/projects/mimeo/) to
      # get a file mimetype, the `file` utility doesn't always work right :(
      defaultApplications = {
        "x-scheme-handler/http" = "app.zen_browser.zen.desktop";
        "x-scheme-handler/https" = "app.zen_browser.zen.desktop";
        "x-scheme-handler/about" = "app.zen_browser.zen.desktop";
        "x-scheme-handler/unknown" = "app.zen_browser.zen.desktop";
        "x-scheme-handler/terminal" = config.my.terminal.desktop;

        "x-scheme-handler/jetbrains" = "jetbrains-toolbox.desktop";
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";

        "text/plain" = "nvim.desktop";
        "text/css" = "nvim.desktop";
        "text/csv" = "nvim.desktop";
        "text/html" = "nvim.desktop";
        "text/calendar" = "nvim.desktop";
        "text/javascript" = "nvim.desktop";
        "text/xml" = "nvim.desktop";
        "text/x-script.python" = "nvim.desktop";
        "text/x-python3" = "nvim.desktop";
        "text/x-ruby" = "nvim.desktop";
        "text/x-crystal" = "nvim.desktop";
        "text/markdown" = "nvim.desktop";
        "text/x-systemd-unit" = "nvim.desktop";
        "application/x-shellscript" = "nvim.desktop";
        "application/json" = "nvim.desktop";
        "application/yaml" = "nvim.desktop";
        "application/sql" = "nvim.desktop";
        "application/vnd.coreos.ignition+json" = "nvim.desktop";

        "image/jpeg" = "imv.desktop";
        "image/bmp" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/tiff" = "imv.desktop";

        "video/mpeg" = "mpv.desktop";
        "video/ogg" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/3gpp" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";

        "audio/mpeg" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";
        "audio/wav" = "mpv.desktop";
        "audio/aac" = "mpv.desktop";
        "audio/flac" = "mpv.desktop";

        "application/pdf" = "org.pwmt.zathura.desktop";

        "inode/directory" = "org.gnome.Nautilus.desktop";
      };
    };
  };
}
