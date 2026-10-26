{ lib, ... }: {
  options.my.core = {
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
    font = lib.mkOption {
      description = "Font related configuration shared between system and home.";
      type = lib.types.submodule {
        options = {
          family = lib.mkOption {
            description = "Default font familly for UI, terminal, etc. Note: should have related package installed in my.core.font.packages.";
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
    identity = {
      username = lib.mkOption {
        type = lib.types.str;
        description = "Default user's username.";
      };
    };
  };
}
