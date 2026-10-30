{
  hostName,
  config,
  lib,
  ...
}:
let
  inherit (config.my.srv) opencode localsrv;
  inherit (config.my.core.microvm) atlas;
in
{
  networking = {
    inherit hostName;
    # Open ports for enabled apps bound to the atlas bridge IP.
    firewall.allowedTCPPorts =
      (lib.optionals (opencode.enable && opencode.ip == atlas.ip && opencode.port != null) [
        opencode.port
      ])
      ++ (lib.optionals (localsrv.enable && localsrv.ip == atlas.ip && localsrv.port != null) [
        localsrv.port
      ]);
  };
}
