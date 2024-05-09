{ lib, ... }: {
  imports = [ <home-manager/nixos> ];

  home-manager.users.risus = { pkgs, ... }: {
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };

    programs.fzf = {
      enable = true;
    };

    programs.eza = {
      enable = true;
    };

    programs.bat = {
      enable = true;
    };

    xdg.configFile."tofi/config".source = ../config/tofi/config;
    xdg.configFile."lvim/config.lua".source = ../config/lvim/config.lua;

    gtk = {
      enable = true;
      theme = {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
    };
    
    # https://discourse.nixos.org/t/virt-manager-cannot-create-vm/38894/2
    # virt-manager doesn't work without it
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
    };
    home.stateVersion = "23.11";
  };
  
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
