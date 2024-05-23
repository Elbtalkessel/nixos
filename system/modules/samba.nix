{ pkgs, ... }:
let
  HOST = "moon";
  MOUNT_OPTS = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users,credentials=/root/secrets/samba,uid=1000,gid=100";
  SHARES = [ "Download" "Video" "Music" "Backup" "Public" ];

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
  # https://nixos.wiki/wiki/Samba
  # Requires secrets file in /root/secrets/samba:
  #   username=<USERNAME>
  #   domain=[DOMAIN]
  #   password=<PASSWORD>
  environment.systemPackages = [ pkgs.cifs-utils ];

  fileSystems = mounts;
}
