# Generic XDG behaviour that is not tied to a single application. Each tool
# config lives in a sibling directory next to this module.
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
      "npm/npmrc".source = ./npm/npmrc;
    };
    autostart.enable = true;
  };
}
