# The colour palette, icon theme and metrics, plus the fold that generates the
# four Material-style colour variants.
#
# Sibling of identity, mail, desktop, fonts and system -- see ./my.nix for how
# these slices combine into the single `my.*` namespace.
{ lib, ... }:
let
  get-color-opts = name: {
    "fg-${name}" = lib.mkOption {
      type = lib.types.str;
      description = "text on ${name} background.";
    };
    "bg-${name}" = lib.mkOption {
      type = lib.types.str;
      description = "background of ${name}.";
    };
    "fg-${name}-container" = lib.mkOption {
      type = lib.types.str;
      description = "text on ${name} container.";
    };
    "bg-${name}-container" = lib.mkOption {
      type = lib.types.str;
      description = "background of ${name} container.";
    };
  };
  color-options = builtins.foldl' (acc: variant: acc // get-color-opts variant) { } [
    "primary"
    "secondary"
    "tertiary"
    "error"
  ];
in
{
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
          color = lib.mkOption {
            type = lib.types.submodule {
              options = {
                dark = lib.mkOption {
                  type = lib.types.submodule {
                    options = color-options // {
                      bg = lib.mkOption {
                        type = lib.types.str;
                        description = "Background color.";
                      };
                      fg = lib.mkOption {
                        type = lib.types.str;
                        description = "Text on background.";
                      };
                      fg-surface = lib.mkOption {
                        type = lib.types.str;
                        description = "Surface background color.";
                      };
                      bg-surface = lib.mkOption {
                        type = lib.types.str;
                        description = "Text on surface.";
                      };
                      green-100 = lib.mkOption {
                        type = lib.types.str;
                        description = "For all green elements.";
                      };
                      green-200 = lib.mkOption {
                        type = lib.types.str;
                        description = "For even greener element.";
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
