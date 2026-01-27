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
      # GNOME uses the same path too,
      # `dconf dump /org/gnome/desktop/wallpaper/`
      wallpaper = {
        path = "${userhome}/.config/background";
        cmd = {
          get = "get-wallpaper";
          set = "set-wallpaper";
        };
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
        };
      };
      opacity = 0.98;
      net-mount = {
        # samba shares should start with `//` !
        # nfs should end with `:` !
        device = "192.168.8.90:";
        mountTo = "/mnt/share";
        fsType = "nfs";
        # full path to each share
        shares = [ "/volume1/xyz" ];
      };
      tailscale = false;
      wm = {
        uwsm.enable = true;
        performance = false;
      };
      virt.docker.gpu.enable = false;
      theme = {
        icon = {
          path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/22x22";
        };
      };
    };
  };
}
