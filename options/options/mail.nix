# Mail credentials and the local IMAP/SMTP bridge.
#
# Sibling of identity, theme, desktop, fonts and system -- see ./my.nix for how
# these slices combine into the single `my.*` namespace.
{ lib, ... }:
{
  options.my = {
    mail = lib.mkOption {
      description = "Mail settings.";
      default = { };
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
