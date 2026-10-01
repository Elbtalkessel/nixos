{ sops-nix, config, ... }: {
  imports = [
    sops-nix.homeManagerModules.sops
  ];

  sops = {
    # defaultSopsFile and defaultSopsFormat are set once in flake.nix.
    age.keyFile = "/home/${config.my.username}/.config/sops/age/keys.txt";
    secrets = {
      "protonmail.bridge.username" = { };
      "protonmail.bridge.password" = { };
    };
  };
}
