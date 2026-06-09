{
  pkgs,
  config,
  lib,
  ...
}:
{
  # https://wiki.nixos.org/wiki/Tailscale
  # Interface trust and open ports are configured in ./security.nix

  services.tailscale = {
    enable = config.my.tailscale;
  };

  # 2. Force tailscaled to use nftables (Critical for clean nftables-only systems)
  # This avoids the "iptables-compat" translation layer issues.
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  # 3. Optimization: Prevent systemd from waiting for network online
  # (Optional but recommended for faster boot with VPNs)
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  systemd.services.tailscale-autoconnect = lib.mkIf config.my.tailscale {
    description = "Automatic connection to Tailscale";
    # make sure tailscale is running before trying to connect to tailscale
    after = [
      "network-pre.target"
      "tailscale.service"
    ];
    wants = [
      "network-pre.target"
      "tailscale.service"
    ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      authkey="$(cat ${config.sops.secrets."tailscale/one-of-key".path})"
      ${pkgs.tailscale}/bin/tailscale up -authkey $authkey;
    '';
  };
}
