_: {
  imports = [
    ./mbsync.nix
    ./notmuch.nix
    ./aerc.nix
  ];
  services = {
    protonmail-bridge = {
      enable = true;
    };
  };
}
