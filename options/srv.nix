{ lib, ... }:
let
  servable =
    {
      name,
      ip ? null,
      port ? null,
      subdomain ? null,
    }:
    lib.types.submodule {
      options = {
        enable = lib.mkEnableOption name;
        ip = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = ip;
          description = "IP address to serve ${name} on.";
        };
        port = lib.mkOption {
          type = lib.types.nullOr lib.types.port;
          default = port;
          description = "Port number to serve ${name} on.";
        };
        proxy = lib.mkEnableOption "proxy";
        subdomain = lib.mkOption {
          type = lib.types.str;
          default = if (subdomain == null) then name else subdomain;
          description = "Subdomain to use in proxy if enabled, defaults to the option name.";
        };
      };
    };
in
{
  # Subgroup of apps, but those can that can be served over http.
  # Some of them have optional web ui (opencode), setting `enable = true`
  # on them will only enable the app.
  # In case if it is purely a web app, just enabling will do nothing meaningful.
  #
  # These options are populated in the hosts/_shared/config.nix because Caddy runs
  # on host, but app itself can run in a vm.
  #
  # Potential improvements:
  #   - Use a list to define any number of services without adding another option here.
  options.my.srv = {
    domain = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "A domain name this host should resolve to.";
    };

    opencode = lib.mkOption {
      type = servable { name = "opencode"; };
    };

    comfyui = lib.mkOption {
      type = servable { name = "comfyui"; };
      description = "ComfyUI options.";
    };

    nsrv = lib.mkOption {
      type = servable { name = "nsrv"; };
      description = "Nsrv options.";
    };

    localsrv = lib.mkOption {
      type = servable { name = "localsrv"; };
      description = "A generic local server.";
    };
  };
}
