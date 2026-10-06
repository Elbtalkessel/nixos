# Values for my.system -- see ../options/system.nix for the declarations.
{ lib, ... }:
let
  inherit (import ./common.nix) userhome;
in
{
  config.my = {
    # Whether the machine joins the tailnet is a host decision, so this is
    # only the default. A host flips it in its nixos.nix -- see hosts/omen.
    tailscale = lib.mkDefault false;

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

    steam.session = true;

    hardware.dgpu.enable = true;
  };
}
