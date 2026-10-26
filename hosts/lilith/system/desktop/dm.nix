{ config, ... }: {
  services.displayManager = {
    enable = true;
    autoLogin = {
      enable = true;
      user = config.my.username;
    };
    ly = {
      enable = true;
      x11Support = false;
    };
  };
}
