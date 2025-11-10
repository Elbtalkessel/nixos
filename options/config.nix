{ pkgs, ... }:
{
  config = {
    my = {
      hyprland-performance = true;
      username = "risus";
      shell = "nu";
      shell-pkg = pkgs.nushell;
      editor = "nvim";
      terminal = {
        pkg = pkgs.foot;
        desktop = "foot.desktop";
        exe = "foot";
      };
      font-family-mono = "OverpassM Nerd Font Mono";
      net-mount = {
        host = "nas.s1.home.arpa";
        mountTo = "/mnt/share";
        type = "nfs";
      };
      tailscale = false;
    };
  };
}
