# The user: who they are, and the tools that identify them.
#
# Sibling of mail, theme, desktop, fonts and system -- see ./my.nix for how these
# slices combine into the single `my.*` namespace.
{ lib, ... }:
{
  options.my = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "Default user's username.";
    };

    avatar = lib.mkOption {
      type = lib.types.str;
      description = "User's avatar.";
      default = "";
    };

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
  };
}
