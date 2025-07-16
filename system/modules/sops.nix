{ config, ... }:
{
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/home/${config.username}/.config/sops/age/keys.txt";
    };
    secrets = {
      "users/${config.username}/password" = {
        # https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
        neededForUsers = true;
      };
      "wireless.env" = { };
      "optimizer/license" = {
        owner = config.users.users.${config.username}.name;
      };
      "wireguard/wg0" = { };
      "moon/${config.username}" = { };
      "moon/webdav" = {
        mode = "0600";
        path = "/etc/davfs2/secrets";
      };
    };
  };
}
