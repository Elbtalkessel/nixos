# Host-side atlas microvm configuration.
# When bridge interface is configured - pins a configured IP.
# In case if domain and IP are configured - uses host's caddy to route traffic to.
# In latter case requires a dns server to point to the machine, configured in the homelab repository
# plus in router setting for static ip lease.
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

  services.caddy.virtualHosts =
    lib.mkIf (atlas.itype == "bridge" && atlas.domain != null && atlas.ip != null)
      {
        "${atlas.domain}" = {
          # The `http://` scheme selects the listener port: a bare hostname is
          # an HTTPS site and binds :443, leaving the :80 firewall hole unused.
          hostName = "http://${atlas.domain}";
          # `hostName` now carries the scheme, so the module's default access-log
          # name would come out as "access-http:__oc.s3.home.arpa.log". Pin it
          # back to the plain host name.
          logFormat = "output file /var/log/caddy/access-${atlas.domain}.log";
          extraConfig = ''
            encode zstd gzip
            reverse_proxy ${atlas.ip}:${toString config.my.apps.opencode.port}
          '';
        };
      };
}
