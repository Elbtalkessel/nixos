{
  noctalia,
  pkgs,
  ...
}:
{
  imports = [
    noctalia.homeModules.default
  ];
  programs.noctalia = {
    enable = true;
  };
  home.packages = with pkgs; [
    ddcutil
  ];
}
