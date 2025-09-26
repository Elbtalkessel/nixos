_: {
  xdg = {
    mimeApps =
      let
        # Comes from flatpak
        browser = "app.zen_browser.zen.desktop";
      in
      {
        enable = true;
        defaultApplications = {
          "text/html" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/about" = browser;
          "x-scheme-handler/unknown" = browser;
          "x-scheme-handler/jetbrains" = "jetbrains-toolbox.desktop";
          "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
          "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
          "inode/directory" = "lf.desktop";
          "text/plain" = "nvim.desktop";
        };
      };

  };
}
