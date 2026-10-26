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
    shell = {
      name = "nu";
      package = pkgs.nushell;
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

    opacity = 0.85;

    terminal = {
      pkg = pkgs.foot;
      desktop = "foot.desktop";
      exe = "foot";
      font-size = 14;
    };

    wm = {
      uwsm.enable = true;
      performance = false;
      bar.provider = "noctalia";
    };

    mail = {
      address = "rtfsc@pm.me";
      password = "proton/bridge password";
      # host / port / sslType carry sensible defaults at the declaration site,
      # so they are not repeated here.
    };

    # theme -- read by panel and session modules in the home tree.
    theme = {
      size.edge-gap = 4.0;
      icon.path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/22x22";
      color = {
        # https://www.logicui.com/colorgenerator
        # Alternating colors, light on dark - dark on light for each variant.
        # TODO: there is a separate palette for noctalia in ~/.config/noctalia/palettes/mine.json
        # I like it more.
        dark = {
          fg-primary = "#C0B1E6";
          bg-primary = "#252526";
          fg-primary-container = "#403266";
          bg-primary-container = "#CBC0E6";
          fg-secondary = "#D8D2E6";
          bg-secondary = "#433E4C";
          fg-secondary-container = "#595366";
          bg-secondary-container = "#DCD8E6";
          fg-tertiary = "#E6C3CE";
          bg-tertiary = "#4C323B";
          fg-tertiary-container = "#66434F";
          bg-tertiary-container = "#E6CDD5";
          fg-error = "#E69490";
          bg-error = "#4C100D";
          fg-error-container = "#661511";
          bg-error-container = "#E6ACA9";
          fg = "#323233";
          bg = "#e4e4e6";
          fg-surface = "#e4e4e6";
          bg-surface = "#191919";
          green-100 = "#8ec07c";
          green-200 = "#26a269";
        };
      };
    };
  };
}
