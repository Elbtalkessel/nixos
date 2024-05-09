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
      libnotify
      hyprpaper
      imv

      # Console and text-based UI apps
      lf
      lazygit
      btop

      # Tools
      arp-scan
      httpie
      ripgrep

      # Editors and IDEs
      lunarvim
      jetbrains.pycharm-professional
      # https://search.nixos.org/packages?channel=23.11&show=github-copilot-intellij-agent&from=0&size=50&sort=relevance&type=packages&query=Copilot
      # The GitHub copilot IntelliJ plugin’s native component. bin/copilot-agent must be symlinked into the plugin directory, replacing the existing binary.
      # For example:
      # ln -fs /run/current-system/sw/bin/copilot-agent ~/.local/share/JetBrains/IntelliJIdea2022.2/github-copilot-intellij/copilot-agent/bin/copilot-agent-linux
      # ln -fs /nix/store/1sl4g8xbcpn8whmihy4ns60kgdc5hhha-github-copilot-intellij-agent-1.2.18.2908/bin/copilot-agent ~/.local/share/JetBrains/PyCharm2023.2/github-copilot-intellij/copilot-agent/bin/copilot-agent-linux
      github-copilot-intellij-agent

      # Dev
      pre-commit
      python311Packages.invoke
      slack
    ];
  };

  # Change runtime directory size
  services.logind.extraConfig = "RuntimeDirectorySize=8G";
}
