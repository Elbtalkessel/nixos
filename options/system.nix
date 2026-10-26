# Machine-level toggles and resources: VPN, storage, virtualisation, Steam and
# hardware.
#
# Sibling of identity, mail, theme, desktop and fonts -- see ./my.nix for how
# these slices combine into the single `my.*` namespace.
{ lib, ... }:
{
  options.my = {
    virt = lib.mkOption {
      type = lib.types.submodule {
        options = {
          docker = lib.mkOption {
            type = lib.types.submodule {
              options = {
                gpu = lib.mkOption {
                  type = lib.types.submodule {
                    options = {
                      enable = lib.mkOption {
                        type = lib.types.bool;
                        description = "Allow docker containers to use GPU";
                        default = false;
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

    hardware = lib.mkOption {
      description = "Hardware toggles.";
      type = lib.types.submodule {
        options = {
          dgpu = lib.mkOption {
            description = "Descreet GPU toggles.";
            type = lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  description = "Completely disable.";
                  default = false;
                };
                passthrough = lib.mkOption {
                  type = lib.types.bool;
                  description = "Passthrough to virtual machine";
                  default = false;
                };
              };
            };
          };
        };
      };
    };
  };
}
