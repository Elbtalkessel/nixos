{ lib, pkgs, ... }:
{
  options.my.apps = {
    editor = lib.mkOption {
      type = lib.types.str;
      description = "The default editor for the user.";
      default = "nvim";
    };

    terminal = lib.mkOption {
      type = lib.types.submodule {
        options = {
          pkg = lib.mkOption {
            type = lib.types.package;
            description = "The default terminal emulator for the user.";
            default = pkgs.foot;
          };
          desktop = lib.mkOption {
            type = lib.types.str;
            description = "Name of .desktop file";
            default = "foot.desktop";
          };
          exe = lib.mkOption {
            type = lib.types.str;
            description = "Name of executable";
            default = "foot";
          };
          font-size = lib.mkOption {
            type = lib.types.int;
            description = "Terminal font size";
            default = 14;
          };
        };
      };
    };

    mail = lib.mkOption {
      description = "Mail settings.";
      type = lib.types.submodule {
        options = {
          password = lib.mkOption {
            type = lib.types.str;
            description = "libsecret {attribue} {value}. To store a value you'll need gnome-keyring and libsecret, example: `echo 'password!' | secret-tool store --label='Protonmail Bridge' proton/bridge password`";
          };
          host = lib.mkOption {
            type = lib.types.str;
            description = "IMAP/SMTP host";
            default = "127.0.0.1";
          };
          port = lib.mkOption {
            type = lib.types.str;
            description = "IMAP/SMPT port";
            default = "1143";
          };
          sslType = lib.mkOption {
            type = lib.types.enum [ "STARTTLS" ];
            default = "STARTTLS";
          };
        };
      };
    };

    steam = lib.mkOption {
      description = "Steam related options.";
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            description = "Deploy steam on this host.";
            default = false;
          };
        };
      };
    };

    git = lib.mkOption {
      description = "Global git options.";
      type = lib.types.submodule {
        options = {
          signingKey = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "gnupg key";
          };
        };
      };
    };
  };
}
