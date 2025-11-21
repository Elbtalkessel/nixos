{ pkgs, ... }:
{
  programs = {
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
        qogir-icon-theme
        steamtinkerlaunch
      ];
      extraCompatPackages = with pkgs; [
        steamtinkerlaunch
      ];
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
}
