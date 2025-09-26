_: {
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        # browser
        "x-scheme-handler/http" = "app.zen_browser.zen.desktop";
        "x-scheme-handler/https" = "app.zen_browser.zen.desktop";
        "x-scheme-handler/about" = "app.zen_browser.zen.desktop";
        "x-scheme-handler/unknown" = "app.zen_browser.zen.desktop";

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

        "image/jpeg" = "imv.desktop";
        "image/bmp" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/tiff" = "imv.desktop";

        "video/mpeg" = "mpv.desktop";
        "video/ogg" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/3gpp" = "mpv.desktop";
        # mkv
        "video/x-matroska" = "mpv.desktop";

        "audio/mpeg" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";
        "audio/wav" = "mpv.desktop";
        "audio/aac" = "mpv.desktop";
        "audio/flac" = "mpv.desktop";
      };
    };

  };
}
