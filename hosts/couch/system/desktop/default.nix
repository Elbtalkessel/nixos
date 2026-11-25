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
let
  # Kodi runs headless on GBM, so there is no display server to VNC into. This
  # is the settings file for Kodi's built-in web server (Chorus2), which is how
  # the box is managed from a browser before a monitor is ever attached.
  # `esallinterfaces` is what allows connections from other machines, not just
  # localhost.
  kodiWebSettings = pkgs.writeText "guisettings.xml" ''
    <settings version="2">
      <setting id="services.webserver" default="true">true</setting>
      <setting id="services.webserverport" default="true">8080</setting>
      <setting id="services.webserverusername" default="true"></setting>
      <setting id="services.webserverpassword" default="true"></setting>
      <setting id="services.esallinterfaces" default="true">true</setting>
      <setting id="services.zeroconf" default="true">true</setting>
    </settings>
  '';
in
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

  # Seed the web-server settings once (only if guisettings.xml is missing) and
  # before greetd starts Kodi, so the first boot is already remote-manageable.
  # Kodi keeps these values when it rewrites the file on exit.
  systemd.services.kodi-webseed = {
    description = "Seed Kodi web server settings if missing";
    wantedBy = [ "multi-user.target" ];
    before = [ "greetd.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      cfg=/home/kodi/.kodi/userdata/guisettings.xml
      if [ ! -e "$cfg" ]; then
        install -d -o kodi -g users -m 0750 "$(dirname "$cfg")"
        install -m 0640 -o kodi -g users "${kodiWebSettings}" "$cfg"
      fi
    '';
  };
}
