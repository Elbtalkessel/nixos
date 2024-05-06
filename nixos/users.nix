{ pkgs, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.risus = {
    isNormalUser = true;
    description = "risus";
    extraGroups = [ "networkmanager" "input" "wheel" "video" "audio" "tss" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINC/PJ5Ll6Z8N0UM+nkMMBCrpf23J963UdeIWZrZjZBg me@0x00.life"
    ];
    shell = pkgs.fish;
    # Note: system-wide packages are in packages.nix
    # Some packages are installed through home-manager in home.nix
    packages = with pkgs; [
      # Web access
      brave
      wget
      curl

      # Capture
      grim
      slurp
      wl-clipboard

      # Desktop environment
      tofi
      zathura

      # Console and text-based UI apps
      lf
      lazygit
      lazydocker
      btop

      # Tools
      arp-scan
      httpie
      ripgrep

      # Editors and IDEs
      lunarvim
    ];
  };

  # Change runtime directory size
  services.logind.extraConfig = "RuntimeDirectorySize=8G";
}
