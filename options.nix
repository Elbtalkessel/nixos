{ lib, ... }:
{
  # https://nlewo.github.io/nixos-manual-sphinx/development/option-types.xml.html
  options = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "risus";
      description = "The username for the home directory.";
    };
    shell = lib.mkOption {
      type = lib.types.str;
      default = "nu";
      description = "The default shell for the user.";
    };
    editor = lib.mkOption {
      type = lib.types.str;
      default = "nvim";
      description = "The default editor for the user.";
    };
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "alacritty";
      description = "The default terminal emulator for the user.";
    };
    browser = lib.mkOption {
      type = lib.types.str;
      default = "vivaldi";
      description = "The default web browser for the user.";
    };
    # TODO(conf): make system/modules/{samba,webdav,sops}.nix toggable and
    # put here common configuration options.
    share = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            host = lib.mkOption {
              type = lib.types.str;
              default = "nas.s1.home.arpa";
              description = "The hostname or IP address of the NAS server.";
            };
            shares = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "List of shares to mount from the NAS server (only if type is set to samba).";
            };
            mountTo = lib.mkOption {
              type = lib.types.str;
              default = "/mnt/share";
              description = "The mount point for the shares.";
            };
            type = lib.mkOption {
              type = lib.types.enum [
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
    # TODO(conf): Add an option combining system/modules/{nvidia,passthrough,llm}.nix
    #   and allowing to disabling / enabling selectively, but not let enable mutually exclusive options.
  };
}
