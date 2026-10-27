{ lib, pkgs, ... }: {
  options.my.core = {
    # Problem: for nushell the package name is nushell, but executable is nu.
    shell = lib.mkOption {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "The default shell for the user.";
            default = "zsh";
          };
          package = lib.mkOption {
            type = lib.types.package;
            description = "Shell package.";
            default = pkgs.zsh;
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
                  default = "OverpassM Nerd Font";
                };
                mono = lib.mkOption {
                  type = lib.types.str;
                  description = "Default monospace font.";
                  default = "OverpassM Nerd Font Mono";
                };
                propo = lib.mkOption {
                  type = lib.types.str;
                  description = "Default prop font.";
                  default = "OverpassM Nerd Propo";
                };
              };
            };
          };
          # Just to have these two in a single place.
          packages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            description = "The same as fonts.packages.";
            default = with pkgs; [
              nerd-fonts.overpass
              noto-fonts-color-emoji
            ];
          };
        };
      };
    };
    identity = {
      username = lib.mkOption {
        type = lib.types.str;
        description = "Default user's username.";
      };
      email = lib.mkOption {
        type = lib.types.str;
        description = "Email address";
      };
    };
    tailscale = lib.mkOption {
      type = lib.types.bool;
      description = "Enable tailscale vpn. Requires tailscale/one-of-key secret.";
      default = false;
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
    microvm = lib.mkOption {
      description = "MicroVM configuration. <host-name> = { }";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            itype = lib.mkOption {
              type = lib.types.nullOr (
                lib.types.enum [
                  "tap"
                  "bridge"
                ]
              );
              default = null;
              description = ''
                Network interface type.
                Null disables guest Ethernet networking.
              '';
            };
            ip = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Pinned IP address on the libvirt network.";
            };
            mac = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "MAC address. Requires itype = bridge";
            };
            domain = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "DNS hostname served by the host's Caddy proxy.";
            };
          };
        }
      );
    };
  };
}
