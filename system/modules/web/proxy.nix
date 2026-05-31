{ pkgs, ... }:
{
  services.caddy = {
    enable = true;
    email = "pieceof@duck.com";
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/BadAimWeeb/caddy-uwsgi-transport@v0.0.0-20240111102235-9529fba1de5d"
      ];
      hash = "sha256-xiZsTnVHhOTFYD5TOwZUG3lrf8ChyZNb+WPP9paINcs=";
    };
  };
}
