{
  lib,
  config,
  ...
}:
let
  isSystem = !(config ? home && config.home ? homeDirectory);
in
{
  sops.secrets = lib.mkMerge [
    {
      "wireless/env" = { };
      "tailscale/one-of-key" = { };
    }

    (lib.mkIf isSystem {
      "users/${config.my.core.identity.username}/password" = {
        neededForUsers = true;
      };
    })
  ];

  my = {
    core = {
      tailscale = true;
      filesystem = {
        network = {
          enable = true;
          device = "192.168.1.90";
          mount = "/mnt/share";
          fsType = "nfs";
          shares = [
            "/volume1/Download"
          ];
        };
      };
      identity.email = "rtfsc@pm.me";
    };
  };
}
