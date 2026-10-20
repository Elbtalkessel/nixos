# Services this machine exposes: bind address and port, one slice per service.
#
# Sibling of identity, mail, theme, desktop, fonts, system and apps -- see
# ./my.nix for how these slices combine into the single `my.*` namespace.
{ lib, ... }:
{
  options.my = {
    service = lib.mkOption {
      type = lib.types.submodule {
        options = {
          opencode = lib.mkOption {
            type = lib.types.submodule {
              options = {
                ip = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                  description = "IP address the opencode web UI binds to. Set to empty to disable web interface.";
                };
                port = lib.mkOption {
                  type = lib.types.port;
                  default = 4096;
                  description = "TCP port the opencode web UI listens on.";
                };
              };
            };
          };
        };
      };
    };
  };
}
