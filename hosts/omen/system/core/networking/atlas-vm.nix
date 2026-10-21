# Pin the atlas microVM's address on the libvirt `default` network (virbr0)
# and make omen's dnsmasq resolve its hostname to that address.
#
# The guest's virtio NIC MAC is fixed in hosts/atlas/nixos.nix, so a DHCP
# host reservation keyed on it always yields the same lease. The reservation
# is applied with `virsh net-update ... --live --config`: `--live` takes
# effect immediately, `--config` persists it in the network XML, and the
# delete-then-add sequence makes the unit idempotent across rebuilds.
{ pkgs, ... }:
let
  atlas = {
    name = "atlas";
    mac = "02:00:00:00:00:01";
    ip = "192.168.122.10";
    domain = "oc.s3.home.arpa";
  };
in
{
  # Local override in the host's own dnsmasq (see modules/system/core/networking/dns.nix):
  # every lookup of the domain (and its subdomains) answers with the pinned IP.
  services.dnsmasq.settings.address = [ "/${atlas.domain}/${atlas.ip}" ];

  systemd.services.atlas-dhcp-reservation = {
    description = "Pin ${atlas.name}'s DHCP reservation in libvirt network default";
    wantedBy = [ "multi-user.target" ];
    after = [ "libvirtd.service" ];
    before = [ "microvm@${atlas.name}.service" ];
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
      "$virsh" net-update default add ip-dhcp-host "<host mac='${atlas.mac}' name='${atlas.name}' ip='${atlas.ip}'/>" --live --config --parent-index 0
    '';
  };
}
