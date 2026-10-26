{
  pkgs,
  lib,
  config,
  ...
}:
let
  isSystem = !(config ? home && config.home ? homeDirectory);
in
{
  sops.secrets = lib.mkMerge [
    {
      "wireless/env" = { };
    }

    (lib.mkIf isSystem {
      "users/${config.my.username}/password" = {
        neededForUsers = true;
      };
    })
  ];

  my = {
    username = "risus";
    shell = {
      name = "zsh";
      package = pkgs.zsh;
    };
    tailscale = true;
    font = {
      family = {
        mono = "OverpassM Nerd Font Mono";
        default = "OverpassM Nerd Font";
        propo = "OverpassM Nerd Propo";
      };
      packages = with pkgs; [
        nerd-fonts.overpass
        noto-fonts-color-emoji
      ];
    };
    filesystem = {
      network = {
        enable = true;
        device = "192.168.1.90";
        mount = "/mnt/share";
        fsType = "nfs";
        shares = [
          "/volume1/xyz"
          "/volume1/Video"
          "/volume1/Download"
        ];
      };
    };
  };
}
