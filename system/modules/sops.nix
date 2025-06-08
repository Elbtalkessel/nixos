{ config, ... }:
{
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/home/risus/.config/sops/age/keys.txt";
    };
    secrets = {
      "users/risus/password" = {
        # https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
        neededForUsers = true;
      };
      "wireless.env" = { };
      "optimizer/license" = {
        owner = config.users.users.risus.name;
      };
      "wireguard/wg0" = { };
      "moon/risus" = { };
      "moon/webdav" = {
        mode = "0600";
        path = "/etc/davfs2/secrets";
      };
    };
  };
}
