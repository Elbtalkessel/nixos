{ pkgs, ... }:
{
  imports = [
    ./dev.nix
  ];

  home.packages = with pkgs; [
    neovim
    gnupg
    file
    xxd
  ];
}
