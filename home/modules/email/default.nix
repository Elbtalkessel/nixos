_: {
  imports = [
    ./mbsync.nix
    ./notmuch.nix
    ./mailmover.nix
    ./aerc.nix
  ];
  services = {
    protonmail-bridge = {
      enable = true;
    };
  };
}
