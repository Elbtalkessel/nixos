{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      jetbrains-toolbox
      fsnotifier
    ];

    #sessionVariables = {
    #  PYCHARM_PROPERTIES = "/home/risus/.config/idea/idea.properties";
    #};
  };

  xdg.configFile = {
    "ideavim/ideavimrc".source = ../config/ideavim/ideavimrc;
  };
}
