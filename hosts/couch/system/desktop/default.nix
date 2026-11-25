# Appliance posture: Kodi IS the session.
#
# Kodi runs standalone on the DRM/KMS (GBM) backend — no X11, no Wayland
# compositor. This is the LibreELEC/OSMC model and Kodi's own recommendation
# for a single-app box: GBM is the only backend with both dynamic refresh-rate
# switching and HDR, and it costs no power running a compositor. Wayland is
# Kodi's least-capable backend (no refresh switching, no HDR on 21.3), so it
# loses here; X11 only matters for Steam, which we do not run (Moonlight is the
# streaming client).
{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.kodi-gbm ];

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${pkgs.kodi-gbm}/bin/kodi-standalone";
        user = "kodi";
      };
    };
  };
}
