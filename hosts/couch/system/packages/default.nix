{ pkgs, ... }:
{
  # Operator tools over SSH + the streaming/emulation clients. Kodi itself is
  # pulled in by the desktop session (kodi-gbm). Apps and plugins beyond this
  # are configured interactively inside Kodi.
  environment.systemPackages = with pkgs; [
    git
    home-manager
    neovim
    curl

    # Game streaming client (native, VA-API decode). Lighter than a full Steam
    # install and the recommended client for Sunshine/GeForce hosts.
    moonlight-qt

    # Emulation front-end; libretro cores are added later from romm.x.home.arpa.
    retroarch

    # Power measurement / debugging.
    powertop
    lm_sensors
  ];
}
