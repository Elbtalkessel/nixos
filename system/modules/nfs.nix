_: {
  services.nfs.server = {
    enable = true;
    exports = ''
      /srv/nfs/work 192.168.122.0/24(insecure,rw,sync,no_subtree_check)
    '';
    # NFSv3 support
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    extraNfsdConfig = '''';
  };
  networking.firewall = {
    allowedTCPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
    allowedUDPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
  };
}
