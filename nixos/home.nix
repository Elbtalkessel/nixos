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
    
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      plugins = [
        {
          name = "tide";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "v6.1.1";
            hash = "sha256-ZyEk/WoxdX5Fr2kXRERQS1U1QHH3oVSyBQvlwYnEYyc=";
          };
        }
      ];
    };

    home.stateVersion = "23.11";
  };
  
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
