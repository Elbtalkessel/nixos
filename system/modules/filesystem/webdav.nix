# WIP: support config.my.filesystem.network
{ config, lib, ... }:
let
  opt = config.my.filesystem.network;
  enable = opt.fsType == "webdav";
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
      description = "webdav at ${opt.device}";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      what = opt.device;
      where = opt.mount;
      options = "uid=1000,gid=1000,file_mode=0664,dir_mode=2775,x-systemd.automount";
      type = "davfs";
      mountConfig.TimeoutSec = 15;
    }
  ];
  systemd.automounts = lib.mkIf enable [
    {
      description = "automount for webdav at ${opt.device}";
      where = opt.mount;
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        TimeoutIdleSec = "2m";
      };
    }
  ];
}
