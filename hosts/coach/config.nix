# Per-host profile for coach.
#
# `my.*` values for this machine. Both trees (NixOS system and Home Manager)
# import this module, so the values are set once and available to either side.
#
# No sops for this host (descriptor has `sops = false`): there is no secrets.yaml
# and no age key. The primary user is key-only over SSH and auto-logs into Kodi.
{
  my = {
    core = {
      identity.email = "rtfsc@pm.me";
    };
  };
}
