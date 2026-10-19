{ pkgs, ... }: {
  home.packages = [
    # `my.editor`, which the desktop package list installs and programs.nix
    # does not.
    pkgs.neovim
    # git.nix sets signing.format = "openpgp", and signing needs a gpg.
    pkgs.gnupg
  ];
}
