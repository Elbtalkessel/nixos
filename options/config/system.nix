# Values for my.system -- see ../options/system.nix for the declarations.
let
  inherit (import ./common.nix) userhome;
in
{
  config.my = {
    tailscale = false;

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
      tagged.mounts = [
        {
          src = userhome;
          dst = "${userhome}/Tag";
        }
      ];
    };

    virt.docker.gpu.enable = true;

    android.enable = true;

    steam.session = true;

    hardware.dgpu.enable = true;
  };
}
