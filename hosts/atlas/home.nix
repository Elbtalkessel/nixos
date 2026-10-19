{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./config.nix

    # The zsh slice of the shell bucket: zsh, starship, devenv, direnv,
    # zoxide, fd, fzf, ripgrep, bat.
    ../../modules/home/core/shell/programs.nix
    ../../modules/home/core/shell/theme.nix

    # opencode itself, the plugin, the skills, and the language servers the
    # lsp MCP probes on PATH.
    ../../modules/home/apps/llm/agent.nix
  ];

  home = {
    inherit (config.my) username;
    homeDirectory = "/home/${config.my.username}";

    sessionVariables.EDITOR = config.my.editor;

    # Matches the release this host was created on.
    stateVersion = "24.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    # `my.editor`, which the desktop package list installs and programs.nix
    # does not.
    pkgs.neovim
    # git.nix sets signing.format = "openpgp", and signing needs a gpg.
    pkgs.gnupg
  ];
}
