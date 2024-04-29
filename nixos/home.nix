{ ... }: {
  imports = [ <home-manager/nixos> ];
  
  home-manager.users.risus = { pkgs, ... }: { 
    programs.git = {
      enable = true;
      userName = "Elbtalkessel";
      userEmail = "rtfsc@pm.me";
      aliases = {
        gitm = "git merge --no-ff";
      };
    };
    home.stateVersion = "23.11";
  };
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
