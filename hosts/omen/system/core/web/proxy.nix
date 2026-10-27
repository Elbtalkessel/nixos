{ config, ... }: {
  services.caddy = {
    enable = true;
    inherit (config.my.core.identity) email;
    openFirewall = true;
  };
}
