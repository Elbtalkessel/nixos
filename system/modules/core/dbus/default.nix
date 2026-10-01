# dbus-broker built with extra logging, see
# https://github.com/NixOS/nixpkgs/issues/303078#issuecomment-4698342707
{
  pkgs,
  ...
}:
{
  services.dbus.brokerPackage = pkgs.dbus-broker.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./dbus-broker-logging.patch
    ];
  });
}
