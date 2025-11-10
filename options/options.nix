{ lib, pkgs, ... }:
let
  t = lib.types;
  opt = lib.mkOption;
in
{
  # https://nlewo.github.io/nixos-manual-sphinx/development/option-types.xml.html
  options = {
    username = opt {
      type = t.str;
      default = "risus";
      description = "The username for the home directory.";
    };
    shell = opt {
      type = t.str;
      default = "nu";
      description = "The default shell for the user.";
    };
    editor = opt {
      type = t.str;
      default = "nvim";
      description = "The default editor for the user.";
    };
    terminal = opt {
      type = t.package;
      default = pkgs.foot;
      description = "The default terminal emulator for the user.";
    };
    font-family-mono = opt {
      type = t.str;
      default = "OverpassM Nerd Font Mono";
      description = "Default monospace font";
    };
    # TODO(conf): make system/modules/{samba,webdav,sops}.nix toggable and
    # put here common configuration options.
    share = opt {
      type = t.attrsOf (
        t.submodule {
          options = {
            host = opt {
              type = t.str;
              default = "nas.s1.home.arpa";
              description = "The hostname or IP address of the NAS server.";
            };
            shares = opt {
              type = t.listOf t.str;
              default = [ ];
              description = "List of shares to mount from the NAS server (only if type is set to samba).";
            };
            mountTo = opt {
              type = t.str;
              default = "/mnt/share";
              description = "The mount point for the shares.";
            };
            type = opt {
              type = t.enum [
                "smb"
                "webdav"
              ];
              default = "webdav";
              description = "The type of the share.";
            };
          };
        }
      );
    };
    tailscale = opt {
      type = t.bool;
      default = false;
      description = "Enable tailscale vpn. Requires tailscale/one-of-key secret.";
    };
    # TODO(conf): Add an option combining system/modules/{nvidia,passthrough,llm}.nix
    #   and allowing to disabling / enabling selectively, but not let enable mutually exclusive options.
    _userc = opt {
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
          };
        };
    };
  };
}
