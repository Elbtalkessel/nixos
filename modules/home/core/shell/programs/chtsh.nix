{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    cht-sh
  ];
  home.sessionVariables = {
    CHTSH = "${config.xdg.configHome}/chtsh";
  };
  xdg.configFile = {
    "chtsh/cht.sh.conf".text = # bash
      ''
        CHTSH_URL=https://cht.x.home.arpa
      '';
  };
}
