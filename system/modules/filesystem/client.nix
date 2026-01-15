{
  pkgs,
  config,
  lib,
  ...
}:
let
  isSmb = config.my.net-mount.fsType == "cifs";
  # Function to generate mount points
  creds = config.sops.secrets."moon/${config.my.username}".path;
  options = [
    "nofail"
    "x-systemd.automount"
    "noauto"
    "x-systemd.idle-timeout=60"
    "x-systemd.device-timeout=5s"
    "x-systemd.mount-timeout=5s"
  ]
  ++ lib.lists.optionals isSmb [
    "uid=1000"
    "gid=100"
    "user,users,credentials=${creds}"
  ];

  mkMount = share: {
    "${config.my.net-mount.mountTo}/${share}" = {
      inherit (config.my.net-mount) fsType;
      inherit options;
      device = "${config.my.net-mount.device}${share}";
    };
  };
  # Generate all mount configurations
  mkMounts = shares: builtins.foldl' (acc: share: acc // mkMount share) { } shares;
in
{
  environment.systemPackages = lib.mkIf isSmb [ pkgs.cifs-utils ];
  fileSystems = mkMounts config.my.net-mount.shares;
}
