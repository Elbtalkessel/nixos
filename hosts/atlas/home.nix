{ config, ... }:
{
  imports = [
    ./config.nix
    ../../modules/home/programs/opencode.nix
    ./home/programs
    ./home/packages
  ];

  home = {
    inherit (config.my) username;
    homeDirectory = "/home/${config.my.username}";

    sessionVariables.EDITOR = config.my.editor;

    # Matches the release this host was created on.
    stateVersion = "26.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
