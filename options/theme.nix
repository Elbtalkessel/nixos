# The colour palette, icon theme and metrics, plus the fold that generates the
# four Material-style colour variants.
#
# Sibling of identity, mail, desktop, fonts and system -- see ./my.nix for how
# these slices combine into the single `my.*` namespace.
{ lib, ... }: {
  options.my = {
    theme = lib.mkOption {
      type = lib.types.submodule {
        options = {
          size = lib.mkOption {
            type = lib.types.submodule {
              options = {
                edge-gap = lib.mkOption {
                  type = lib.types.float;
                  description = "Gap between a window and the edge of screen.";
                };
              };
            };
          };
          icon = lib.mkOption {
            type = lib.types.submodule {
              options = {
                path = lib.mkOption {
                  type = lib.types.str;
                  description = "Icon theme path.";
                };
              };
            };
          };
        };
      };
    };
  };
}
