{ lib, ... }: {
  imports = [ <home-manager/nixos> ];

  home-manager.users.risus = { pkgs, ... }: {
    programs.git = {
      enable = true;
      userName = "Elbtalkessel";
      userEmail = "rtfsc@pm.me";
      aliases = {
        m = "merge --no-ff";
      };
    };
  };
}
