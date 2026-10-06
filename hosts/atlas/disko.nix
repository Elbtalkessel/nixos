# Disk layout for atlas, the opencode VM.
#
# Deliberately unencrypted. This machine runs agents against code that already
# exists on the workstation, holds no credentials of its own beyond the Gitea
# MCP token (which lives in sops, not on disk), and a LUKS root would ask for a
# passphrase on every boot of a machine you normally reach over SSH.
#
# Compare `virt/disko.nix`, which does encrypt: the difference is the host's
# choice, not a difference in the layout's shape.
#
# There is no swap partition. Nix builds are the only thing on this host that
# can outgrow RAM, and the VM's disk is cheap -- grow the `main` partition or
# add zramSwap in `nixos.nix` if a build starts getting OOM-killed.
{

  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "EFI";
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            main = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "defaults"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
