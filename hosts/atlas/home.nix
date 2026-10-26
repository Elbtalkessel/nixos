{ config, ... }:
{
  imports = [
    ./config.nix
    ../../modules/home/programs/opencode.nix
    ./home/programs
    ./home/packages
    ./home/services
  ];

  home = {
    inherit (config.my.core.identity) username;
    homeDirectory = "/home/${config.my.core.identity.username}";

    sessionVariables.EDITOR = config.my.editor;

    # Matches the release this host was created on.
    stateVersion = "26.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
