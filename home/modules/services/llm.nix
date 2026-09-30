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

  home.sessionVariables = {
    OMO_DISABLE_POSTHOG = "1";
    OMO_SEND_ANONYMOUS_TELEMETRY = "0";
  };

  home.packages = [
    pkgs.lmstudio
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.skills
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.oh-my-opencode

    # oh-my-openagent runtime dependencies: the git-master skill and team-mode
    # drive gh, and the lsp MCP probes these binaries by name on PATH.
    pkgs.gh

    # the lsp MCP launches packages/lsp-daemon/dist/cli.js with node or bun
    # resolved from PATH; with neither present it registers as disabled.
    pkgs.nodejs
    pkgs.gopls
    pkgs.bash-language-server
    pkgs.lua-language-server
    pkgs.pyright
    pkgs.yaml-language-server
  ];
}
