# Host-side atlas microvm configuration.
# When a bridge interface is configured, this pins the DHCP reservation.
# When a domain and IP are also configured, the host's Caddy reverse-proxies
# traffic to the guest. DNS for the domain is handled externally; see
# https://gitea.x.home.arpa/devops/homelab/commit/8664bd31ceeeb8b84e1beb9f01551948de97933d
{
  pkgs,
  config,
  lib,
  ...
}:
let
  atlas = config.my.core.microvm.atlas;
in
{
  systemd.services.atlas-dhcp-reservation = (lib.mkIf (atlas.itype == "bridge" && atlas.ip != null)) {
    description = "Pin atlas's DHCP reservation in libvirt network default";
    wantedBy = [ "multi-user.target" ];
    after = [ "libvirtd.service" ];
    before = [ "microvm@atlas.service" ];
    wants = [ "libvirtd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      virsh="${pkgs.libvirt}/bin/virsh"

      # The network is defined once libvirtd has started and copied its XML
      # (libvirtd-config); net-info succeeds for both active and inactive
      # networks, so it is the readiness check.
      until "$virsh" net-info default >/dev/null 2>&1; do
        sleep 2
      done

      # Activate if autostart has not already done so; an "already active"
      # or a racing activation is not an error here.
      "$virsh" net-start default >/dev/null 2>&1 || true

      # Drop any stale reservation for this MAC before re-adding the
      # authoritative mapping; nothing matching (first run) is not an error.
      "$virsh" net-update default delete ip-dhcp-host "<host mac='${atlas.mac}'/>" --live --config >/dev/null 2>&1 || true

      # Failure here is a unit failure: the pin genuinely could not be applied.
      "$virsh" net-update default add ip-dhcp-host "<host mac='${atlas.mac}' name='atlas' ip='${atlas.ip}'/>" --live --config --parent-index 0
    '';
  };
}
