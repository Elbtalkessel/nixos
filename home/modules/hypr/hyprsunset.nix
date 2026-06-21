{ config, ... }:
{
  services.hyprsunset = {
    enable = config.my.wm.bar.provider != "noctalia";
    settings = {
      profile = [
        {
          temperature = 4500;
        }
      ];
    };
  };
}
