{ pkgs, ... }:
{
  # PROGRAMS
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    # virt-manager requires dconf to remember settings
    dconf.enable = true;
    nix-ld.enable = true;
    nix-ld.libraries = [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
    ];
    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
    };
    zsh.enable = true;
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
  ];
}
