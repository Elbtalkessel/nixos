_: {
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
  };
}
