{ lib, ... }:
{
  options.my = {
    editor = lib.mkOption {
      type = lib.types.str;
      description = "The default editor for the user.";
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
          };
        };
      };
    };
  };
}
