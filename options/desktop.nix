# The desktop experience: wallpaper, terminal, opacity, and the window-manager
# session settings.
#
# Sibling of identity, mail, theme, fonts and system -- see ./my.nix for how
# these slices combine into the single `my.*` namespace.
{ lib, ... }:
{
  options.my = {
    opacity = lib.mkOption {
      type = lib.types.float;
      description = "Opacity value between 1 (no opacity) and 0.0 (opaque) applied where it can (terminal, launcher).";
    };

    wm = lib.mkOption {
      type = lib.types.submodule {
        options = {
          performance = lib.mkOption {
            type = lib.types.bool;
            description = "Enable performance mode.";
          };
          uwsm = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  description = "Enable UWSM support.";
                };
              };
            };
          };
          bar = lib.mkOption {
            type = lib.types.submodule {
              options = {
                provider = lib.mkOption {
                  type = lib.types.enum [
                    "noctalia"
                  ];
                  description = "Bar provider";
                };
              };
            };
          };
        };
      };
    };
  };
}
