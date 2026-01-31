{ lib, ... }:
let
  opt = lib.mkOption;
  get-color-opts = name: {
    "fg-${name}" = opt {
      type = lib.types.str;
      description = "text on ${name} background.";
    };
    "bg-${name}" = opt {
      type = lib.types.str;
      description = "background of ${name}.";
    };
    "fg-${name}-container" = opt {
      type = lib.types.str;
      description = "text on ${name} container.";
    };
    "bg-${name}-container" = opt {
      type = lib.types.str;
      description = "background of ${name} container.";
    };
  };
  color-options = builtins.foldl' (acc: variant: acc // get-color-opts variant) { } [
    "primary"
    "secondary"
    "tertiary"
    "error"
  ];
in
{
  # https://nlewo.github.io/nixos-manual-sphinx/development/option-types.xml.html
  options = {
    # TODO(conf): Add an option combining system/modules/{nvidia,passthrough,llm}.nix
    #   and allowing to disabling / enabling selectively, but not let enable mutually exclusive options.
    my = opt {
      description = "Frequently changed / shared settings.";
      type =
        with lib.types;
        submodule {
          options = {
            username = opt {
              type = str;
              description = "Default user's username.";
            };
            avatar = opt {
              type = str;
              description = "User's avatar.";
            };
            wallpaper = opt {
              type = submodule {
                options = {
                  path = opt {
                    type = str;
                    description = "Absolute path to a wallpaper.";
                  };
                  cmd = opt {
                    type = submodule {
                      options = {
                        set = opt {
                          type = str;
                          description = "Name of a wallpaper setter command.";
                          default = "set-wallpaper";
                        };
                        get = opt {
                          type = str;
                          description = "Name of a wallpaper gett command.";
                          default = "get-wallpaper";
                        };
                      };
                    };
                  };
                };
              };
            };
            # Problem: for nushell the package name is nushell, but executable is nu.
            shell = opt {
              type = submodule {
                options = {
                  name = opt {
                    type = str;
                    description = "The default shell for the user.";
                  };
                  package = opt {
                    type = package;
                    description = "Shell package.";
                  };
                };
              };
            };
            editor = opt {
              type = str;
              description = "The default editor for the user.";
            };
            terminal = opt {
              type = submodule {
                options = {
                  pkg = opt {
                    type = package;
                    description = "The default terminal emulator for the user.";
                  };
                  desktop = opt {
                    type = str;
                    description = "Name of .desktop file";
                  };
                  exe = opt {
                    type = str;
                    description = "Name of executable";
                  };
                };
              };
            };
            font = opt {
              type = submodule {
                options = {
                  family = opt {
                    type = submodule {
                      options = {
                        mono = opt {
                          type = str;
                          description = "Default monospace font";
                        };
                        default = opt {
                          type = str;
                          description = "Default font";
                        };
                      };
                    };
                  };
                };
              };
            };
            tailscale = opt {
              type = bool;
              description = "Enable tailscale vpn. Requires tailscale/one-of-key secret.";
            };
            opacity = opt {
              type = float;
              description = "Opacity value between 1 (no opacity) and 0.0 (opaque) applied where it can (terminal, launcher).";
            };
            # TODO(conf): make system/modules/{samba,webdav,sops}.nix toggable and
            # put here common configuration options.
            net-mount = opt {
              type = submodule {
                options = {
                  device = opt {
                    type = str;
                    description = "The hostname or IP address of the NAS server.";
                  };
                  shares = opt {
                    type = listOf str;
                    default = [ ];
                    description = "List of shares to mount from the NAS server (only if type is set to samba).";
                  };
                  mountTo = opt {
                    type = str;
                    description = "The mount point for the shares.";
                  };
                  fsType = opt {
                    type = enum [
                      "cifs"
                      "nfs"
                    ];
                    description = "The type of the share.";
                  };
                };
              };
            };
            wm = opt {
              type = submodule {
                options = {
                  performance = opt {
                    type = bool;
                    default = false;
                    description = "Enable performance mode.";
                  };
                  uwsm = opt {
                    type = submodule {
                      options = {
                        enable = opt {
                          type = bool;
                          description = "Enable UWSM support.";
                          default = true;
                        };
                      };
                    };
                  };
                  bar = opt {
                    type = submodule {
                      options = {
                        provider = opt {
                          type = enum [
                            "ashell"
                            "hyprpanel"
                            "waybar"
                          ];
                          description = "Bar provider";
                        };
                      };
                    };
                  };
                };
              };
            };
            virt = opt {
              type = submodule {
                options = {
                  docker = opt {
                    type = submodule {
                      options = {
                        gpu = opt {
                          type = submodule {
                            options = {
                              enable = opt {
                                type = bool;
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
            theme = opt {
              type = submodule {
                options = {
                  icon = opt {
                    type = submodule {
                      options = {
                        path = opt {
                          type = str;
                          description = "Icon theme path.";
                        };
                      };
                    };
                  };
                  color = opt {
                    type = submodule {
                      options = {
                        dark = opt {
                          type = submodule {
                            options = color-options // {
                              bg = opt {
                                type = str;
                                description = "Background color.";
                              };
                              fg = opt {
                                type = str;
                                description = "Text on background.";
                              };
                              fg-surface = opt {
                                type = str;
                                description = "Surface background color.";
                              };
                              bg-surface = opt {
                                type = str;
                                description = "Text on surface.";
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
            # add more into my/options here.
          }; # ./options
        }; # ./submodule
    }; # ./my
  }; # /options
}
