{
  comfyui-nix,
  config,
  lib,
  ...
}:
let
  port = 8188;
  ip = "127.0.0.1";
in
{
  imports = [ comfyui-nix.nixosModules.default ];

  nix.settings = lib.mkIf config.my.apps.comfyui.enable {
    substituters = [
      "https://cache.nixos.org"
      "https://comfyui.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  services.comfyui = lib.mkIf config.my.apps.comfyui.enable {
    enable = true;
    gpuSupport = "cuda"; # Enable NVIDIA GPU acceleration (recommended for most users)
    enableManager = true; # Enable the built-in ComfyUI Manager
    inherit port;
    listenAddress = ip; # Use "0.0.0.0" for network access
    #dataDir = "/var/lib/comfyui";
    openFirewall = false;
    extraArgs = [ "--lowvram" ];
    user = config.my.core.identity.username;
    group = "users";
    createUser = false;
    # environment = { };
  };

  services.caddy.virtualHosts =
    lib.mkIf (config.my.apps.comfyui.enable && config.my.apps.comfyui.domain != null)
      {
        "${config.my.apps.comfyui.domain}" = {
          # The `http://` scheme selects the listener port: a bare hostname is
          # an HTTPS site and binds :443, leaving the :80 firewall hole unused.
          hostName = "http://${config.my.apps.comfyui.domain}";
          # `hostName` now carries the scheme, so the module's default access-log
          # name would come out as "access-http:__oc.s3.home.arpa.log". Pin it
          # back to the plain host name.
          logFormat = "output file /var/log/caddy/access-${config.my.apps.comfyui.domain}.log";
          extraConfig = ''
            encode zstd gzip
            reverse_proxy ${ip}:${toString port}
          '';
        };
      };
}
