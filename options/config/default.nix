_: {
  imports = [
    ./identity.nix
    ./mail.nix
    ./theme.nix
    ./desktop.nix
    ./fonts.nix
    ./system.nix
    # ./common.nix is a plain attribute set, not a module, so it is imported by
    # the files that need it rather than listed here.
  ];
}
