{
  pkgs,
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
      "protonmail/bridge/username" = { };
      "protonmail/bridge/password" = { };
    }

    (lib.mkIf isSystem {
      "users/${config.my.core.identity.username}/password" = {
        neededForUsers = true;
      };
    })
  ];

  my = {
    core = {
      shell = {
        name = "nu";
        package = pkgs.nushell;
      };
      tailscale = true;
      filesystem = {
        network = {
          enable = true;
          device = "192.168.1.90";
          mount = "/mnt/share";
          fsType = "nfs";
          shares = [
            "/volume1/xyz"
            "/volume1/Video"
          ];
        };
      };
      virt.docker.gpu.enable = true;
      hardware.dgpu.enable = true;
    };
    apps = {
      mail = {
        address = "rtfsc@pm.me";
        password = "proton/bridge password";
        # host / port / sslType carry sensible defaults at the declaration site,
        # so they are not repeated here.
      };
    };
  };
}
