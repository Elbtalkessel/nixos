{ pkgs, ... }: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Increase quantum in order to fix "crackling" sound in games.
    extraConfig = {
      pipewire = {
        "99-quantum" = {
          "context.properties" = {
            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 512;
          };
        };
      };
    };
    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-disable-handsfree.conf" ''
          wireplumber.settings = {
            bluetooth.autoswitch-to-headset-profile = false
          }
        '')
      ];
    };
  };
}
