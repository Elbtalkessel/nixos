{
  pkgs,
  config,
  lib,
  ...
}:
let
  opt = config.my.filesystem.network;
  shares = if opt.enable then opt.shares else [ ];
  isSmb = if opt.enable then opt.fsType == "cifs" else false;

  creds = if isSmb then config.sops.secrets."moon/${config.my.username}".path else "";
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

  host = (
    {
      "cifs" = "//${opt.device}";
      "nfs" = "${opt.device}:";
    }
    ."${opt.fsType}"
  );
  mkMount = share: {
    "${opt.mount}/${share}" = {
      inherit (opt) fsType;
      inherit options;
      device = "${host}${share}";
    };
  };
  # Generate all mount configurations
  mkMounts = shares: builtins.foldl' (acc: share: acc // mkMount share) { } shares;
in
{
  environment.systemPackages = lib.mkIf isSmb [ pkgs.cifs-utils ];
  fileSystems = mkMounts shares;
}
