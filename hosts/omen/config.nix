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
    # Tree-agnostic declarations -- both NixOS-system and Home Manager
    # trees accept these option names.
    {
      "wireless.env" = { };
      "wireguard/wg0" = { };
      "moon/${config.my.username}" = { };
      "moon/webdav" = {
        mode = "0600";
        path = "/etc/davfs2/secrets";
      };
      "tailscale/one-of-key" = { };
      "vaultwarden.env" = { };
      # Per-host runtime env for opencode. `nix-skills`'s home-manager
      # module reads this through `programs.opencode.web.environmentFile`;
      # both omen and atlas run opencode, so both hosts decrypt it.
      "opencode/env" = { };
      # Protonmail bridge credentials -- consumed by the protonmail-bridge
      # application in the home tree. The system tree also materialises
      # them (under `/run/secrets/`) but no service reads from there.
      "protonmail.bridge.username" = { };
      "protonmail.bridge.password" = { };
    }

    # System-tree-only secrets. Passwords must exist before user creation
    # on first activation, so we mark them `neededForUsers`.
    (lib.mkIf isSystem {
      "users/${config.my.username}/password" = {
        neededForUsers = true;
      };
      "users/steamos/password" = {
        neededForUsers = true;
      };
    })
  ];

  # Start the atlas microvm on boot.
  microvm.autostart = [ "atlas" ];

  my = {
    # identity -- username + login shell, both required and required-but-no-default.
    username = "risus";
    shell = {
      name = "nu";
      package = pkgs.nushell;
    };
    editor = "nvim";
    # Avatar path defers to the merged username: the module system defers
    # evaluation, so the order of these assignments does not matter.
    avatar = "/home/${config.my.username}/.cache/avatar";

    # system toggles -- read by `modules/system/core/*`.
    tailscale = true;
    steam.session = true;
    virt.docker.gpu.enable = true;
    hardware.dgpu.enable = true;

    # filesystem mounts -- read by `modules/system/core/storage` and
    # `modules/home/apps/files/tag`.
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

    # fonts -- read by `core/fonts` (system) and the panel / launchers / theme
    # modules (home).
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

    # desktop experience -- read by `modules/home/desktop/*` and the terminals.
    opacity = 0.85;

    wallpaper = {
      path = "/home/${config.my.username}/.config/background";
      source = "/home/${config.my.username}/Pictures/Wallpaper";
      random = {
        enable = false;
        timer = "3m";
      };
      cmd.set = "set-wallpaper";
    };

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

    # mail -- read by `modules/home/apps/mail/*`.
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
