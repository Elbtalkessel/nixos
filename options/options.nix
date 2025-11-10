{ lib, ... }:
let
  opt = lib.mkOption;
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
            hyprland-performance = opt {
              type = bool;
              default = false;
              description = "Performance mode switching off all animations.";
            };
            username = opt {
              type = str;
              description = "Default user's username.";
            };
            # TODO(conf): One setting for shell?
            #   Problem: for nushell the package name is nushell, but executable is nu.
            shell = opt {
              type = str;
              description = "The default shell for the user.";
            };
            shell-pkg = opt {
              type = package;
              description = "Shell package.";
            };
            editor = opt {
              type = str;
              description = "The default editor for the user.";
            };
            terminal = opt {
              type = package;
              description = "The default terminal emulator for the user.";
            };
            font-family-mono = opt {
              type = str;
              description = "Default monospace font";
            };
            tailscale = opt {
              type = bool;
              description = "Enable tailscale vpn. Requires tailscale/one-of-key secret.";
            };
            # TODO(conf): make system/modules/{samba,webdav,sops}.nix toggable and
            # put here common configuration options.
            net-mount = opt {
              type = submodule {
                options = {
                  host = opt {
                    type = str;
                    description = "The hostname or IP address of the NAS server.";
                  };
                  smb-shares = opt {
                    type = listOf str;
                    default = [ ];
                    description = "List of shares to mount from the NAS server (only if type is set to samba).";
                  };
                  mountTo = opt {
                    type = str;
                    description = "The mount point for the shares.";
                  };
                  type = opt {
                    type = enum [
                      "smb"
                      "webdav"
                      "nfs"
                    ];
                    description = "The type of the share.";
                  };
                };
              };
            };
          };
        };
    };
  };
}
