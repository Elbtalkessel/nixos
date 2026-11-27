{ pkgs, nix-flatpak, ... }:
{
  imports = [
    nix-flatpak.nixosModules.nix-flatpak
  ];

  services = {
    desktopManager = {
      plasma6.enable = true;
    };
    displayManager = {
      plasma-login-manager.enable = true;
      defaultSession = "plasma-bigscreen-wayland";
      autoLogin = {
        enable = true;
        user = "htpc";
      };
      sessionPackages = [
        pkgs.kdePackages.plasma-bigscreen
      ];
    };
    flatpak = {
      enable = true;
      packages = [
        "org.libretro.RetroArch"
        "com.github.tchx84.Flatseal"
        "rocks.shy.VacuumTube"
        "tv.plex.PlexHTPC"
        "tv.kodi.Kodi"
      ];
    };
  };

  # flatpak requirement
  xdg.portal.enable = true;

  environment.systemPackages = with pkgs.kdePackages; [
    plasma-bigscreen
    plasma-nano
    plasma-nm
    plasma-pa
    milou
    kscreen
    kdeconnect-kde
    kwallet
    kwalletmanager
    kwallet-pam

    discover

    krdp
  ];
}
