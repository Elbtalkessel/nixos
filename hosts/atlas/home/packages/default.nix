{ pkgs, ... }:
{
  imports = [
    ./dev.nix
    ./scripts
  ];

  home.packages = with pkgs; [
    neovim
    gnupg
    file
    xxd
  ];
}
