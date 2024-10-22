{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      jetbrains-toolbox
      fsnotifier
    ];

    file = {
      ".ideavimrc".source = ../config/.ideavimrc;
    };
  };
}
