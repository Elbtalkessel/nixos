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
      "wget/wgetrc".source = ./wget/wgetrc;
      # TMPFS caching, https://github.com/direnv/direnv/wiki/Customizing-cache-location#direnv-cache-on-tmpfs
      "direnv/direnvrc".source = ./direnv/direnvrc;
      "process-compose/settings.yaml".source = ./process-compose/settings.yaml;
      "npm/npmrc".source = ./npm/npmrc;
    };
    autostart.enable = true;
  };
}
