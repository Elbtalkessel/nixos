{ config, ... }:
{
  imports = [
    ./config.nix

    ../../modules/home/core/environment
    ../../modules/home/core/diagnostics
    ../../modules/home/core/identity
    ../../modules/home/core/mime-apps
    ../../modules/home/core/removable-media
    ../../modules/home/core/shell
    ../../modules/home/core/theme
    ../../modules/home/core/tools
    ../../modules/home/core/xdg

    ../../modules/home/desktop/launchers
    ../../modules/home/desktop/notifications
    ../../modules/home/desktop/panel
    ../../modules/home/desktop/session
    ../../modules/home/desktop/wallpaper

    ../../modules/home/apps/browser
    ../../modules/home/apps/files
    ../../modules/home/apps/ide
    ../../modules/home/apps/image-viewer
    ../../modules/home/apps/llm
    ../../modules/home/apps/mail
    ../../modules/home/apps/media
    ../../modules/home/apps/terminals
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    inherit (config.my) username;
    homeDirectory = "/home/${config.my.username}";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  # quemu requiers it, but virtualisation settings are part of the
  # system configuration, not home. So it is here.
  dconf = {
    settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
