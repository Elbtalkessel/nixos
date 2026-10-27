{ config, ... }:
{
  imports = [
    ./config.nix

    ../_shared/programs/git.nix

    ./home/apps
    ./home/core
    ./home/desktop
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    inherit (config.my.core.identity) username;
    homeDirectory = "/home/${config.my.core.identity.username}";

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
