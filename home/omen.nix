{ config, lib, ... }:
{
  imports = [
    ./environment.nix
    ./modules/bar
    ./modules/hypr
    ./modules/launcher
    ./modules/explorer
    ./modules/term
    ./modules/android.nix
    ./modules/apps.nix
    ./modules/game.nix
    ./modules/git.nix
    ./modules/mako.nix
    ./modules/qutebrowser.nix
    ./modules/browser.nix
    ./modules/gpg.nix
    ./modules/passman.nix
    ./modules/imv.nix
    ./modules/music.nix
    ./modules/ide.nix
    ./modules/theme.nix
    ./modules/packages.nix
    ./modules/wallpaper.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    inherit (config.my) username;
    homeDirectory = "/home/${config.my.username}";

    activation = {
      # https://github.com/philj56/tofi/issues/115#issuecomment-1701748297
      regenerateTofiCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        tofi_cache=${config.xdg.cacheHome}/tofi-drun
        [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
      '';
    };

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

  services = {
    # USB automount
    udiskie = {
      enable = true;
      notify = true;
      automount = true;
    };
  };

  xdg.configFile = {
    "wget/wgetrc".source = ./config/wget/wgetrc;
    # TMPFS caching, https://github.com/direnv/direnv/wiki/Customizing-cache-location#direnv-cache-on-tmpfs
    "direnv/direnvrc".source = ./config/direnv/direnvrc;
    "process-compose/settings.yaml".source = ./config/process-compose/settings.yaml;
    "npm/npmrc".source = ./config/npm/npmrc;
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
