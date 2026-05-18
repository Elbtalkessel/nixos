{ pkgs, ... }:
let
  username = "risus";
  userhome = "/home/${username}";
in
{
  config = {
    my = {
      inherit username;
      # I don't need these paths in store and usually
      # modules using these confs don't need them too.
      avatar = "${userhome}/.cache/avatar";
      wallpaper = {
        path = "${userhome}/.config/background";
        source = "${userhome}/Pictures/Wallpaper";
        random.timer = "3m";
        random.enable = false;
        cmd.set = "set-wallpaper";
      };
      shell = {
        name = "nu";
        package = pkgs.nushell;
      };
      editor = "nvim";
      terminal = {
        pkg = pkgs.foot;
        desktop = "foot.desktop";
        exe = "foot";
      };
      font = {
        family = {
          mono = "OverpassM Nerd Font Mono";
          default = "OverpassM Nerd Font";
          propo = "OverpassM Nerd Propo";
        };
      };
      opacity = 0.80;
      filesystem = {
        network = {
          enable = true;
          device = "192.168.8.90";
          mount = "/mnt/share";
          fsType = "nfs";
          shares = [ "/volume1/xyz" ];
        };
        tagged = {
          mounts = [
            {
              src = "${userhome}/Pictures";
              dst = "${userhome}/Pictures/bytag";
            }
          ];
        };
      };
      tailscale = false;
      wm = {
        uwsm.enable = true;
        performance = false;
        bar.provider = "waybar";
      };
      virt.docker.gpu.enable = false;
      theme = {
        size = {
          edge-gap = 4.0;
        };
        icon = {
          path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/22x22";
        };
        color = {
          # https://www.logicui.com/colorgenerator
          # Alternating colors, ligh on dark - dark on light for each variant.
          dark = {
            fg-primary = "#C0B1E6";
            bg-primary = "#30254C";
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
          };
        };
      };
      android = {
        enable = true;
      };
    };
  };
}
