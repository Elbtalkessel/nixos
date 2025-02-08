{ pkgs, ... }:
{
  home.packages = [
    pkgs.redshift
  ];

  services = {
    redshift = {
      enable = true;

      temperature = {
        day = 5500;
        night = 3700;
      };

      dawnTime = "6:00-7:45";
      duskTime = "18:35-20:15";

      settings = {
        redshift = {
          brightness-day = "1";
          brightness-night = "0.8";
        };
      };
    };
  };
}
