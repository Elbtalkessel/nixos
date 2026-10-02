# The home side of atlas: opencode with the oh-my-openagent plugin, devenv,
# and a zsh to run both in. Nothing from the desktop buckets.
#
# `modules/home/core/shell` is taken file by file instead of through its
# `default.nix`, because that barrel imports `./nushell` and would install the
# one shell this host is not meant to have. `aliases.nix` is left out for the
# same kind of reason: its poweroff/reboot/logout aliases call `hyprshutdown`,
# which needs a display, and its `sp`/`g`/`d` aliases point at packages that
# come with the desktop tool list. The systemd shorthands it also carries are
# worth having, so they are restated below rather than inherited and patched.
{
  pkgs,
  config,
  ...
}:
{
  imports = [
    # The zsh slice of the shell bucket: zsh, starship, devenv, direnv,
    # zoxide, fd, fzf, ripgrep, bat.
    ../../modules/home/core/shell/programs.nix
    ../../modules/home/core/shell/theme.nix

    # opencode itself, the plugin, the skills, and the language servers the
    # lsp MCP probes on PATH.
    ../../modules/home/apps/llm

    # The opencode and omo configuration, which is host-specific because the
    # provider points at the workstation by LAN address.
    ./opencode
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

  home.shellAliases =
    let
      Su = "systemctl --user";
      S = "systemctl";
    in
    {
      inherit Su S;

      usta = "${Su} start";
      usto = "${Su} stop";
      ures = "${Su} restart";
      ustat = "${Su} status";
      urel = "${Su} daemon-reload";
      ucat = "${Su} cat";
      utimer = "${Su} list-timers";
      usvc = "${Su} --type=service";

      ssta = "${S} start";
      ssto = "${S} stop";
      sres = "${S} restart";
      sstat = "${S} status";
      srel = "${S} daemon-reload";
      scat = "${S} cat";
      stimer = "${S} list-timers";
      ssvc = "${S} --type=service";

      cp = "cp -iv";
      ln = "ln -v";
      mv = "mv -iv";
      rm = "rm -v";

      poweroff = "${S} poweroff";
      reboot = "${S} reboot";
    };
}
