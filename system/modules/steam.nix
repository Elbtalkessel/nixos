{ pkgs, ... }:
{
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
  environment = {
    systemPackages = with pkgs; [
      mangohud
      (writeShellScriptBin "gs-launcher" (builtins.readFile ../bin/gs-launcher.sh))
    ];
  };
  hardware.xone.enable = true;
}
