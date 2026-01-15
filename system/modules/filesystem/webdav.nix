# WIP: support config.my.net-mount
{ config, lib, ... }:
let
  enable = config.my.net-mount.fsType == "webdav";
in
{
  services = {
    davfs2 = {
      inherit enable;
    };
  };
  systemd.mounts = lib.mkIf enable [
    {
      inherit enable;
      description = "webdav at ${config.my.net-mount.host}";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      what = config.my.net-mount.host;
      where = config.my.net-mount.mountTo;
      options = "uid=1000,gid=1000,file_mode=0664,dir_mode=2775,x-systemd.automount";
      type = "davfs";
      mountConfig.TimeoutSec = 15;
    }
  ];
  systemd.automounts = lib.mkIf enable [
    {
      description = "automount for webdav at ${config.my.net-mount.host}";
      where = config.my.net-mount.mountTo;
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        TimeoutIdleSec = "2m";
      };
    }
  ];
}
