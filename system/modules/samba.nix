{ pkgs, config, ... }:
let
  HOST = "moon";
  MOUNT_OPTS = "nofail,x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users,credentials=${
    config.sops.secrets."moon/${config.username}".path
  },uid=1000,gid=100";
  SHARES = [
    "Documents"
    "Download"
    "Music"
    "Pictures"
  ];

  # Function to generate mount points
  generateMounts = share: {
    "/mnt/share/${share}" = {
      device = "//${HOST}/${share}";
      fsType = "cifs";
      options = [ MOUNT_OPTS ];
    };
  };

  # Generate all mount configurations
  mounts = builtins.foldl' (acc: share: acc // generateMounts share) { } SHARES;
in
{
  environment.systemPackages = [ pkgs.cifs-utils ];

  fileSystems = mounts;
}
