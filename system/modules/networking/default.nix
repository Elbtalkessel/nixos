_: {
  imports = [
    ./dns.nix
    ./networking.nix
    ./security.nix
    ./tailscale.nix
    ./localsend.nix
    ./ssh.nix
  ];
  networking.hostName = "omen";
}
