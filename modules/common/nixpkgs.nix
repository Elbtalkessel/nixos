# The nixpkgs overlays, shared by the NixOS system tree and the home-manager
# tree.
#
# This is a module rather than a `pkgs = import nixpkgs { overlays = [ ... ]; }`
# binding in flake.nix for one reason: a tree that is handed a pre-built package
# set ignores `nixpkgs.overlays` and `nixpkgs.config` outright -- "Ignored when
# `nixpkgs.pkgs` is set", nixos/modules/misc/nixpkgs.nix. Both trees set the
# option instead, and both import nixpkgs themselves from `nixpkgs.pkgsPath`.
#
# The same is true of the unfree allowlist, which is why there is none here: it
# lives next to each package that needs it, as
# `nixpkgs.config.allowUnfreePackages`. That option merges additively across
# modules, so a module declares the packages it uses and nothing else has to
# know about them. See modules/system/apps/steam/default.nix.
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
