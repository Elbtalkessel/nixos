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
  };
}
