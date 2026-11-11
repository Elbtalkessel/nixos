{
  pkgs,
  config,
  lib,
  ...
}:
{
  # PROGRAMS
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    # virt-manager requires dconf to remember settings
    dconf.enable = true;
    nix-ld.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
    };
  };

  environment.shells = [
    config.my.core.shell.package
  ];

  # https://wiki.nixos.org/wiki/Nushell
  programs.bash = lib.mkIf (config.my.core.shell.name == "nu") {
    interactiveShellInit = ''
      if ! [ "$TERM" = "dumb" ] && [ -z "$BASH_EXECUTION_STRING" ]; then
        exec nu
      fi
    '';
  };

  # Allows executing *.AppImage by directly invoking it,
  # without using `appimage-run` package, e.g. ./Something.AppImage.
  # https://nixos.wiki/wiki/Appimage
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    firejail.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    lm_sensors
    home-manager
    git
    neovim
    curl
    solaar
    gparted
    # gparted requirement to work with NTFS file systems.
    ntfs3g
  ];
}
