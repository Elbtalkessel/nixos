{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs = rec {
    steam = {
      enable = lib.mkDefault true;
      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = false;
      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = false;
      # Open ports in the firewall for Steam Local Network Game Transfers
      localNetworkGameTransfers.openFirewall = false;
      gamescopeSession.enable = config.my.steam.session;
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
  environment = {
    systemPackages = lib.mkIf config.my.steam.session [
      pkgs.mangohud
      (pkgs.writeShellScriptBin "launch-gs" ''
        #!/usr/bin/env bash
        set -xeuo pipefail
        gamescopeArgs=(
          --adaptive-sync # VRR support
          --hdr-enabled
          --mangoapp # performance overlay
          --rt
          --steam
        )
        steamArgs=(
          -pipewire-dmabuf
          -tenfoot
        )
        mangoConfig=(
          cpu_temp
          gpu_temp
          ram
          vram
        )
        mangoVars=(
          MANGOHUD=1
          MANGOHUD_CONFIG="$(IFS=,; echo "''${mangoConfig[*]}")"
        )
        export "''${mangoVars[@]}"
        exec gamescope "''${gamescopeArgs[@]}" -- steam "''${steamArgs[@]}"
      '')
    ];
  };
}
