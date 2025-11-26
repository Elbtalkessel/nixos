{ pkgs, ... }:
{
  programs = rec {
    steam = {
      enable = true;
      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = false;
      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = false;
      # Open ports in the firewall for Steam Local Network Game Transfers
      localNetworkGameTransfers.openFirewall = false;
      gamescopeSession.enable = false;
      extraPackages = with pkgs; [
        steamtinkerlaunch
      ];
      extraCompatPackages = with pkgs; [
        # steam -> game -> props -> force compat tool -> use steam tinker launch
        # to install mods.
        steamtinkerlaunch
      ];
      protontricks.enable = true;
    };
    gamescope = {
      inherit (steam.gamescopeSession) enable;
      capSysNice = true;
    };
    gamemode.enable = true;
  };
  # voice server
  services.murmur = {
    enable = true;
    openFirewall = true;
  };
}
