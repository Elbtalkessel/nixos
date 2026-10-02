# The desktop experience: wallpaper, terminal, opacity, and the window-manager
# session settings.
#
# Sibling of identity, mail, theme, fonts and system -- see ./my.nix for how
# these slices combine into the single `my.*` namespace.
{ lib, ... }:
{
  options.my = {
    wallpaper = lib.mkOption {
      type = lib.types.submodule {
        options = {
          path = lib.mkOption {
            type = lib.types.str;
            description = "Default path to read wallpaper from.";
            default = "";
          };
          source = lib.mkOption {
            type = lib.types.str;
            description = "A path to set wallpaper from. In case of directory, a random wallpaper will be selected.";
            default = "";
          };
          random = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  description = "Enable random wallpaper rotation.";
                  default = false;
                };
                timer = lib.mkOption {
                  type = lib.types.str;
                  description = "Time between changing wallpaper using systemd notation (For example 5s.)";
                  default = "3m";
                };
              };
            };
          };
          cmd = lib.mkOption {
            type = lib.types.submodule {
              options = {
                set = lib.mkOption {
                  type = lib.types.str;
                  description = "Name of a wallpaper setter command.";
                  default = "set-wallpaper";
                };
              };
            };
          };
        };
      };
    };

    terminal = lib.mkOption {
      type = lib.types.submodule {
        options = {
          pkg = lib.mkOption {
            type = lib.types.package;
            description = "The default terminal emulator for the user.";
          };
          desktop = lib.mkOption {
            type = lib.types.str;
            description = "Name of .desktop file";
          };
          exe = lib.mkOption {
            type = lib.types.str;
            description = "Name of executable";
          };
          font-size = lib.mkOption {
            type = lib.types.int;
            description = "Terminal font size";
            default = 14;
          };
        };
      };
    };

    opacity = lib.mkOption {
      type = lib.types.float;
      description = "Opacity value between 1 (no opacity) and 0.0 (opaque) applied where it can (terminal, launcher).";
    };

    wm = lib.mkOption {
      type = lib.types.submodule {
        options = {
          performance = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable performance mode.";
          };
          uwsm = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  description = "Enable UWSM support.";
                  default = true;
                };
              };
            };
          };
          bar = lib.mkOption {
            type = lib.types.submodule {
              options = {
                provider = lib.mkOption {
                  type = lib.types.enum [
                    "ashell"
                    "waybar"
                    "quickshell"
                    "wayle"
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
