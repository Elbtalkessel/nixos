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
      "tailscale/one-of-key" = { };
      "protonmail/bridge/username" = { };
      "protonmail/bridge/password" = { };
    }

    (lib.mkIf isSystem {
      "users/${config.my.username}/password" = {
        neededForUsers = true;
      };
    })
  ];

  my = {
    core = {
      shell = {
        name = "nu";
        package = pkgs.nushell;
      };
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
    };
    editor = "nvim";
    tailscale = true;
    steam.session = true;
    virt.docker.gpu.enable = true;
    hardware.dgpu.enable = true;

    filesystem = {
      network = {
        enable = true;
        device = "192.168.1.90";
        mount = "/mnt/share";
        fsType = "nfs";
        shares = [
          "/volume1/xyz"
          "/volume1/Video"
        ];
      };
    };
    desktop = {
      opacity = 0.85;
      gaps = 4.0;
      manager = {
        uwsm.enable = true;
        performance = false;
      };
      shell.provider = "noctalia";
    };

    terminal = {
      pkg = pkgs.foot;
      desktop = "foot.desktop";
      exe = "foot";
      font-size = 14;
    };

    mail = {
      address = "rtfsc@pm.me";
      password = "proton/bridge password";
      # host / port / sslType carry sensible defaults at the declaration site,
      # so they are not repeated here.
    };
  };
}
