_: {
  services = {
    davfs2.enable = true;
  };
  systemd.mounts = [
    {
      enable = true;
      description = "Moon's root webdav";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      what = "http://192.168.1.90:9800";
      where = "/mnt/share";
      options = "uid=1000,gid=1000,file_mode=0664,dir_mode=2775,x-systemd.automount";
      type = "davfs";
      mountConfig.TimeoutSec = 15;
    }
  ];
  systemd.automounts = [
    {
      description = "Moon's root webdav";
      where = "/mnt/share";
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        TimeoutIdleSec = "2m";
      };
    }
  ];
}
