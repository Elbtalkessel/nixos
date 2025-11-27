{
  pkgs,
  config,
  lib,
  ...
}:
let
  enable = config.my.net-mount.type == "smb";
  # Function to generate mount points
  mkMount = share: {
    "${config.my.net-mount.mountTo}/${share}" = {
      device = "//${config.my.net-mount.host}/${share}";
      fsType = "cifs";
      options =
        let
          creds = config.sops.secrets."moon/${config.my.username}".path;
        in
        [
          "nofail"
          "x-systemd.automount"
          "noauto"
          "x-systemd.idle-timeout=60"
          "x-systemd.device-timeout=5s"
          "x-systemd.mount-timeout=5s"
          "user,users,credentials=${creds}"
          "uid=1000"
          "gid=100"
        ];
    };
  };
  # Generate all mount configurations
  mkMounts = shares: builtins.foldl' (acc: share: acc // mkMount share) { } shares;
in
{
  environment.systemPackages = lib.mkIf enable [ pkgs.cifs-utils ];
  fileSystems = lib.mkIf enable (mkMounts config.my.net-mount.smb-shares);
}
