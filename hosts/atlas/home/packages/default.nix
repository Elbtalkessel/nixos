{ pkgs, ... }:
{
  imports = [
    ./dev.nix
    ./scripts.nix
  ];

  home.packages = with pkgs; [
    neovim
    gnupg
    file
    xxd
  ];
}
