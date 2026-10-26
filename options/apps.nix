{ lib, ... }:
{
  options.my = {
    apps.editor = lib.mkOption {
      type = lib.types.str;
      description = "The default editor for the user.";
    };

    terminal = lib.mkOption {
      type = lib.types.submodule {
        options = {
          pkg = lib.mkOption {
            type = lib.types.package;
            description = "The default terminal emulator for the user.";
          };
          desktop = lib.mkOption {
            type = lib.types.str;
            description = "Name of .desktop file";
          };
          exe = lib.mkOption {
            type = lib.types.str;
            description = "Name of executable";
          };
          font-size = lib.mkOption {
            type = lib.types.int;
            description = "Terminal font size";
          };
        };
      };
    };

    apps.mail = lib.mkOption {
      description = "Mail settings.";
      type = lib.types.submodule {
        options = {
          address = lib.mkOption {
            type = lib.types.str;
            description = "Email address";
          };
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
  };
}
