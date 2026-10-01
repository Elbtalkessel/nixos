# Generic XDG behaviour that is not tied to a single application. Each tool
# config lives in a sibling directory next to this module.
_:

{
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
    configFile = {
      "wget/wgetrc".source = ./xdg/wget/wgetrc;
      # TMPFS caching, https://github.com/direnv/direnv/wiki/Customizing-cache-location#direnv-cache-on-tmpfs
      "direnv/direnvrc".source = ./xdg/direnv/direnvrc;
      "process-compose/settings.yaml".source = ./xdg/process-compose/settings.yaml;
      "npm/npmrc".source = ./xdg/npm/npmrc;
    };
    autostart.enable = true;
  };
}
