{ noctalia, config, ... }:
let
  enable = config.my.wm.bar.provider == "noctalia";
in
{
  imports = [
    noctalia.homeModules.default
  ];
  programs.noctalia = {
    inherit enable;
    systemd = {
      inherit enable;
    };
  };
}
