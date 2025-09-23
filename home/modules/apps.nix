{ pkgs, ... }:
{
  xdg = {
    desktopEntries = {
      lf = {
        name = "LF (Terminal File Manager)";
        genericName = "File Manager";
        exec = "${pkgs.lf}/bin/lf %U";
        terminal = true;
        type = "Application";
        icon = "folder";
        mimeType = "inode/directory";
        categories = [
          "System"
          "Utility"
        ];
      };

      nvim = {
        name = "Neovim";
        genericName = "Text Editor";
        exec = "${pkgs.neovim}/bin/nvim %F";
        terminal = true;
        type = "Application";
        icon = "nvim";
        mimeType = "text/plain";
        categories = [
          "Utility"
          "TextEditor"
        ];
      };
    };
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
          # Fix me, reference in files where it actually installed?
          "x-scheme-handler/jetbrains" = "jetbrains-toolbox.desktop";
          "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
          "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
          "inode/directory" = "lf.desktop";
          "text/plain" = "nvim.desktop";
        };
      };

  };
}
