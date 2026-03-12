{ config, lib, ... }:
let
  group = handler: mimes: lib.genAttrs mimes (_: handler);
in
{
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      # Prefer using mimeo (https://xyne.dev/projects/mimeo/) to
      # get a file mimetype, the `file` utility doesn't always work right :(
      defaultApplications = lib.mergeAttrsList [
        (group "app.zen_browser.zen.desktop" [
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/about"
          "x-scheme-handler/unknown"
        ])
        (group config.my.terminal.desktop [ "x-scheme-handler/terminal" ])
        (group "jetbrains-toolbox.desktop" [ "x-scheme-handler/jetbrains" ])
        (group "org.telegram.desktop.desktop" [
          "x-scheme-handler/tg"
          "x-scheme-handler/tonsite"
        ])
        (group "nvim.desktop" [
          "text/plain"
          "text/css"
          "text/csv"
          "text/html"
          "text/calendar"
          "text/javascript"
          "text/xml"
          "text/x-script.python"
          "text/x-python3"
          "text/x-ruby"
          "text/x-crystal"
          "text/markdown"
          "text/x-systemd-unit"
          "text/x-go"
          "application/x-shellscript"
          "application/json"
          "application/yaml"
          "application/sql"
          "application/vnd.coreos.ignition+json"
        ])
        (group "imv.desktop" [
          "image/jpeg"
          "image/bmp"
          "image/png"
          "image/tiff"
        ])
        (group "mpv.desktop" [
          "video/mpeg"
          "video/ogg"
          "video/webm"
          "video/3gpp"
          "video/x-matroska"
          "image/gif"
        ])
        (group "org.pwmt.zathura.desktop" [ "application/pdf" ])
        (group "org.gnome.Nautilus.desktop" [ "inode/directory" ])
      ];
    };
  };
}
