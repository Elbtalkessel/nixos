# Fonts, shared between the system fontconfig and the home-manager tools that
# render text.
#
# Sibling of identity, mail, theme, desktop and system -- see ./my.nix for how
# these slices combine into the single `my.*` namespace.
{ lib, ... }:
{
  options.my = {
    font = lib.mkOption {
      default = { };
      description = "Font related configuration shared between system and home.";
      type = lib.types.submodule {
        options = {
          family = lib.mkOption {
            default = { };
            description = "Default font familly for UI, terminal, etc. Note: should have related package installed in my.font.packages.";
            type = lib.types.submodule {
              options = {
                default = lib.mkOption {
                  type = lib.types.str;
                  description = "Default font.";
                };
                mono = lib.mkOption {
                  type = lib.types.str;
                  description = "Default monospace font.";
                };
                propo = lib.mkOption {
                  type = lib.types.str;
                  description = "Default prop font.";
                };
              };
            };
          };
          # Just to have these two in a single place.
          packages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            description = "The same as fonts.packages.";
          };
        };
      };
    };
  };
}
