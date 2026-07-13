{ sops-nix, config, ... }: {
  imports = [
    sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${config.my.username}/.config/sops/age/keys.txt";
    secrets = {
      "protonmail/bridge" = { };
    };
  };
}
