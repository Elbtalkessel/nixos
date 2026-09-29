{
  pkgs,
  nix-skills,
  llm-agents,
  ...
}:
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
    package = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
  };

  programs.nix-skills = {
    enable = true;
    agents = [ "opencode" ];
  };

  home.packages = [
    pkgs.lmstudio
  ];
}
