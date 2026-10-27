{ config, ... }: {
  services.displayManager = {
    enable = true;
    autoLogin = {
      enable = true;
      user = config.my.core.identity.username;
    };
    ly = {
      enable = true;
      x11Support = false;
    };
  };
}
