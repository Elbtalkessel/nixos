_: {
  imports = [
    ./dns.nix
    ./networking.nix
    ./security.nix
    ./tailscale.nix
    ./localsend.nix
  ];
  networking.hostName = "omen";
}
