{
  pkgs,
  nix-skills,
  llm-agents,
  sops-nix,
  config,
  ...
}:
{
  imports = [
    nix-skills.homeManagerModules.default
    sops-nix.homeManagerModules.sops
  ];
  sops.secrets."opencode/env" = { };
  programs.opencode = {
    enable = true;
    package = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
    web = {
      enable = true;
      environmentFile = toString config.sops.secrets."opencode/env".path;
      extraArgs = [
        "--hostname"
        "0.0.0.0"
        "--port"
        "4096"
        "--mdns"
      ];
    };
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
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.skills
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.oh-my-opencode
    # pkgs.vllm is intentionally absent: it is built without CUDA and would
    # also collide with the container-backed `vllm` script from
    # ../packages/scripts/vllm.nu.

    # oh-my-openagent runtime dependencies: the git-master skill and team-mode
    # drive gh, and the lsp MCP probes these binaries by name on PATH.
    pkgs.gh

    pkgs.tmux

    # the lsp MCP launches packages/lsp-daemon/dist/cli.js with node or bun
    # resolved from PATH; with neither present it registers as disabled.
    pkgs.nodejs
    pkgs.gopls
    pkgs.bash-language-server
    pkgs.lua-language-server
    pkgs.pyright
    pkgs.yaml-language-server
    pkgs.nixd
    pkgs.nil

    # tools MCP
    pkgs.gitea-mcp-server
  ];
}
