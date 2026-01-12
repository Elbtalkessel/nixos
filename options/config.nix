{ pkgs, ... }:
{
  config = {
    my = {
      username = "risus";
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
      font-family-mono = "OverpassM Nerd Font Mono";
      font-family = "OverpassM Nerd Font";
      opacity = 0.98;
      net-mount = {
        host = "nas.s1.home.arpa";
        mountTo = "/mnt/share";
        type = "nfs";
        smb-shares = [
          "Calibre"
          "Docker"
          "Documents"
          "Download"
          "Home"
          "Pictures"
          "Whatever"
          "Video"
        ];
      };
      tailscale = false;
      wm = {
        uwsm.enable = true;
        performance = false;
      };
    };
  };
}
