# Machine-level toggles and resources: VPN, storage, virtualisation, Steam and
# hardware.
#
# Sibling of identity, mail, theme, desktop and fonts -- see ./my.nix for how
# these slices combine into the single `my.*` namespace.
{ lib, ... }:
{
  options.my = {
    tailscale = lib.mkOption {
      type = lib.types.bool;
      description = "Enable tailscale vpn. Requires tailscale/one-of-key secret.";
    };

    filesystem = lib.mkOption {
      type = lib.types.submodule {
        options = {
          network = lib.mkOption {
            description = "Unified interface for declaring network mounts.";
            type = lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  description = "Enable network mount.";
                  default = false;
                };
                device = lib.mkOption {
                  type = lib.types.str;
                  description = "The hostname or IP address of a server.";
                  example = "192.168.1.1 or http(s)://192.168.1.1[:<port>] for davfs";
                };
                shares = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                  description = "List of shares to mount. Default is empty -- set this to opt in.";
                  example = lib.literalExpression ''
                    [ "/volume1/documents" ]
                  '';
                };
                mount = lib.mkOption {
                  type = lib.types.str;
                  description = "The mount point for the shares.";
                  example = "/mnt";
                };
                fsType = lib.mkOption {
                  type = lib.types.enum [
                    "cifs"
                    "nfs"
                    "davfs"
                  ];
                  description = "The type of the share. davfs is untested.";
                };
              };
            };
          };
          tagged = lib.mkOption {
            type = lib.types.submodule {
              options = {
                mounts = lib.mkOption {
                  default = [ ];
                  description = ''
                    List of tagged filesystem mounts.

                    Each entry specifies a source tag/label that gets mounted to a path.
                    Example: source "bar" → path "/mnt/bar"
                  '';
                  example = lib.literalExpression ''
                    [
                      { path = "/mnt/foo"; source = "bar"; }
                    ]
                  '';
                  type = lib.types.listOf (
                    lib.types.submodule {
                      options = {
                        dst = lib.mkOption {
                          type = lib.types.str;
                          description = "Mount to";
                        };
                        src = lib.mkOption {
                          type = lib.types.str;
                          description = "Mount from";
                        };
                      };
                    }
                  );
                };
              };
            };
          };
          exports = lib.mkOption {
            default = [ ];
            description = "Local filesystem exports to network";
            type = lib.types.listOf (
              lib.types.submodule {
                options = {
                  protocol = lib.mkOption {
                    type = lib.types.enum [ "cifs" ];
                    description = "Sharing protocol";
                  };
                  allow = lib.mkOption {
                    type = lib.types.str;
                    description = "IPs allowed to use the share.";
                  };
                  deny = lib.mkOption {
                    type = lib.types.str;
                    description = "IPs denied to use the share.";
                  };
                  path = lib.mkOption {
                    type = lib.types.str;
                    description = "Local path to share.";
                  };
                  auth = lib.mkOption {
                    type = lib.types.str;
                    description = "Require or not authentication";
                  };
                };
              }
            );
          };
        };
      };
    };

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

    steam = lib.mkOption {
      description = "Steam related options.";
      type = lib.types.submodule {
        options = {
          session = lib.mkOption {
            type = lib.types.bool;
            description = "WIP: Create separate session for log-in into steamos-like interface.";
            default = false;
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
