{ lib, ... }:
{
  options.my = {
    # Problem: for nushell the package name is nushell, but executable is nu.
    shell = lib.mkOption {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "The default shell for the user.";
          };
          package = lib.mkOption {
            type = lib.types.package;
            description = "Shell package.";
          };
        };
      };
    };

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
