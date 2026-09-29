{ pkgs, nix-skills, ... }:
{
  imports = [
    nix-skills.homeManagerModules.default
  ];

  services.ollama = {
    enable = false;
    package = pkgs.ollama-cuda;
  };

  programs.opencode = {
    enable = true;
  };

  programs.nix-skills = {
    enable = true;
    agents = [ "opencode" ];
  };

  home.packages = with pkgs; [
    lmstudio
  ];
}
