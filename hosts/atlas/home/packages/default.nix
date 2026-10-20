{ pkgs, ... }: {
  home.packages = with pkgs; [
    neovim
    gnupg
    file
    xxd
  ];
}
