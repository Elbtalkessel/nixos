{
  config,
  ...
}:
let
  opt = config.my.core.filesystem.network;
  shares = if opt.enable then opt.shares else [ ];

  options = [
    "nofail"
    "x-systemd.automount"
    "noauto"
    "x-systemd.idle-timeout=60"
    "x-systemd.device-timeout=5s"
    "x-systemd.mount-timeout=5s"
  ];

  mkMount = share: {
    "${opt.mount}/${share}" = {
      fsType = "nfs";
      inherit options;
      device = "${opt.device}:${share}";
    };
  };

  # Generate all mount configurations.
  mkMounts = shares: builtins.foldl' (acc: share: acc // mkMount share) { } shares;
in
{
  fileSystems = mkMounts shares;
}
