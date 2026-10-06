# atlas -- a headless VM that runs opencode with the oh-my-openagent plugin.
#
# It borrows only the system modules that have no hardware behind them:
#
#   locale         UTF-8 locale and the timezone, so command output is not
#                  mangled by the POSIX default
#   nix-settings   trusted-users, which is what lets devenv manage its own
#                  caches, plus the numtide substituter that serves the
#                  llm-agents packages opencode is installed from
#
# The rest of `modules/system/core/` is written against omen's hardware and is
# deliberately left behind. The user account is declared here rather than
# imported from `core/users`, because those modules put nushell in
# `users.defaultUserShell` and add desktop groups (`video`, `audio`, `input`)
# that do not exist without the desktop modules.
{
  pkgs,
  lib,
  modulesPath,
  config,
  disko,
  sops-nix,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    disko.nixosModules.disko
    ./disko.nix

    ../../modules/system/core/locale
    ../../modules/system/core/nix-settings

    sops-nix.nixosModules.sops
  ];

  networking.hostName = "atlas";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # A new host, so start at the release the system is actually built from.
  system.stateVersion = "26.11";

  # The disko layout carries an ESP, so `nixos-install` needs a bootloader for
  # the result to be bootable.
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    device = "/dev/vda";
  };

  networking.networkmanager.enable = true;

  # The documented install flow configures the machine over SSH.
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  # zsh, not the nushell that `my.shell` names: this is a remote shell host, and
  # the opencode TUI is drawn in it.
  #
  # Home Manager owns the zsh configuration, but the login shell still has to
  # come from the system closure, and `programs.zsh.enable` is what puts the nix
  # directories in its PATH.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # sops uses its default keyFile, /etc/nixos/age.key, so the documented
  # `cp keys.txt /mnt/etc/nixos/age.key` install step is the whole bootstrap.
  #
  # Only the login password is read here. `core/secrets` would additionally
  # hand this machine the NAS credentials, the WireGuard key and the rest of
  # omen's secret set, none of which belong on a VM.
  sops.secrets."users/${config.my.username}/password" = {
    # The password has to exist before activation creates the account, so it
    # cannot wait for the sops service to come up after the switch.
    # https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
    neededForUsers = true;
  };

  users.users.${config.my.username} = {
    isNormalUser = true;
    description = "atlas opencode host";
    hashedPasswordFile = config.sops.secrets."users/${config.my.username}/password".path;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    useDefaultShell = true;
  };

  # home-manager needs the age key under $HOME, not just /etc/nixos, to
  # decrypt the Gitea MCP token that `opencode/default.nix` reads. The system
  # key is already on disk at this point, so seed the user copy from it instead
  # of making it a second manual install step.
  #
  # Seeded only when absent: keys.txt is the user's to extend, and a later
  # activation must not silently drop a key they added by hand.
  system.activationScripts.age-key-to-home = ''
    age_dir="/home/${config.my.username}/.config/sops/age"
    install -d -m 0700 -o ${config.my.username} "$age_dir"
    if [ ! -e "$age_dir/keys.txt" ]; then
      install -m 0600 -o ${config.my.username} /etc/nixos/age.key "$age_dir/keys.txt"
    fi
  '';
}
