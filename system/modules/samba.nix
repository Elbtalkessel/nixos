{ pkgs, ... }:
let
  HOST = "moon";
  MOUNT_OPTS = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users,credentials=/root/secrets/samba,uid=1000,gid=1000";
in
{
  # https://nixos.wiki/wiki/Samba
  # Requires secrets file in /root/secrets/samba:
  #   username=<USERNAME>
  #   domain=[DOMAIN]
  #   password=<PASSWORD>
  environment.systemPackages = [ pkgs.cifs-utils ];

  fileSystems."/mnt/share/Backup" = {
    device = "//${HOST}/share/Backup";
    fsType = "cifs";
    options = [ "${MOUNT_OPTS}" ];
  };
}
