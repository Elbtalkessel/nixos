{
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
      gamescopeSession = {
        enable = config.my.steam.session;
        args = [
          "--rt"
          "--steam"
        ];
      };
      protontricks.enable = true;
    };
    gamescope = {
      inherit (steam.gamescopeSession) enable;
      # https://github.com/NixOS/nixpkgs/issues/351516
      capSysNice = false;
    };
    gamemode.enable = true;
  };

  # This contain a bunch of udev rules for various usb/bluetooth controllers,
  # mostly focused on giving access to hidraw interface and allowing non-root user
  # to use a device.
  # https://github.com/ValveSoftware/steam-devices/blob/master/60-steam-input.rules
  # https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/nixos/modules/hardware/steam-hardware.nix
  # Removing doesn't change anything
  hardware.steam-hardware.enable = lib.mkDefault config.programs.steam.enable;

  # Among rules above there is a rule for a steam controller to wakeup computer from sleep.
  # For "some" reason linux tries to change attribute of all attached devices.
  services.udev.extraRules = ''
    # Only enable wakeup when power/wakeup attribute exists
    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/wakeup", ATTR{power/wakeup}="enabled"
  '';
}
