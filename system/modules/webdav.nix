_: {
  services = {
    davfs2.enable = true;
  };
  systemd.mounts = [
    {
      enable = true;
      description = "Moon's webdav";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      what = "https://192.168.1.90:9802";
      where = "/mnt/share/moon";
      options = "uid=1000,gid=1000,file_mode=0664,dir_mode=2775";
      type = "davfs";
      mountConfig.TimeoutSec = 15;
    }
  ];
}
