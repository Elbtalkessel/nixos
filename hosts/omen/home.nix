{ config, ... }:
{
  imports = [
    ../../home/environment.nix

    ../../home/modules/core/diagnostics.nix
    ../../home/modules/core/identity/git.nix
    ../../home/modules/core/identity/gpg.nix
    ../../home/modules/core/mime-apps.nix
    ../../home/modules/core/removable-media.nix
    ../../home/modules/core/secrets.nix
    ../../home/modules/core/shell
    ../../home/modules/core/theme.nix
    ../../home/modules/core/tools
    ../../home/modules/core/xdg-config.nix

    ../../home/modules/desktop/launchers
    ../../home/modules/desktop/notifications.nix
    ../../home/modules/desktop/panel
    ../../home/modules/desktop/session
    ../../home/modules/desktop/wallpaper.nix

    ../../home/modules/apps/browser
    ../../home/modules/apps/files
    ../../home/modules/apps/ide
    ../../home/modules/apps/image-viewer
    ../../home/modules/apps/llm.nix
    ../../home/modules/apps/mail
    ../../home/modules/apps/media
    ../../home/modules/apps/terminals
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
