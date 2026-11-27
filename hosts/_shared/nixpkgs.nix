# The nixpkgs overlays, shared by the NixOS system tree and the home-manager
# tree.
{
  nixpkgs-custom,
  nuenv,
  nixvim,
  lib,
  ...
}:
{
  nixpkgs.overlays = [
    nixpkgs-custom.overlays.default
    nuenv.overlays.default
    (_final: prev: {
      # An overlay is `final: prev:`, two arguments -- nixpkgs applies it with
      # both. `prev.stdenv` rather than `final.stdenv` because the system
      # string is all this needs and `prev` is not part of the fixpoint.
      neovim = nixvim.packages.${prev.stdenv.hostPlatform.system}.default;
    })
  ];
  # Only one module in a tree can set `allowUnfreePredicate`: the config
  # attribute is merged with `recursiveUpdate`, so a second definition would
  # replace this one rather than add to it. `allowUnfreePackages` has no such
  # limit and is the right tool everywhere else.
  nixpkgs.config = {
    allowUnfreePredicate = pkg: lib.hasPrefix "cuda" (lib.getName pkg);
  };
}
