# MicroVM host: declares the guests it runs and provisions their sops keys.
#
# Each guest's age key is copied from the admin machine's sops directory into
# a virtiofs share the guest mounts at /etc/sops-nix. The key never enters
# the Nix store; only the copy script does.
{
  lib,
  pkgs,
  self,
  hostDescriptor,
  microvm,
  ...
}:
let
  guests = hostDescriptor.microvmHost;

  copyGuestSopsKey =
    guest:
    pkgs.writeShellScript "microvm-${guest}-sops-key" ''
      src="/home/risus/.config/sops/age/${guest}.age.key"
      dst="/var/lib/microvm/${guest}/sops-nix/key.txt"
      if [[ ! -e "$src" ]]; then
        echo "ERROR: sops age key for microvm ${guest} not found at $src" >&2
        exit 1
      fi
      install -D -m 0640 -o root -g users "$src" "$dst"
    '';
in
{
  imports = [ microvm.nixosModules.host ];

  microvm.vms = lib.genAttrs guests (_: {
    flake = self;
    updateFlake = "git+https://gitea.x.home.arpa/nix/nixos.git";
  });

  # The share directory must exist before the copy service and the microvm
  # start. 0755 so the guest can traverse it (the key stays 0640 root:users).
  systemd.tmpfiles.rules = map (
    guest: "d /var/lib/microvm/${guest}/sops-nix 0755 root users - -"
  ) guests;

  # Copy the per-guest age key from the admin machine's sops directory into
  # the virtiofs share. The key never enters the Nix store; it is read from
  # the host filesystem at microvm start time.
  systemd.services = lib.listToAttrs (
    map (
      guest:
      lib.nameValuePair "microvm-${guest}-sops-key" {
        description = "Copy sops age key for microvm ${guest}";
        before = [ "microvm@${guest}.service" ];
        requiredBy = [ "microvm@${guest}.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = copyGuestSopsKey guest;
        };
      }
    ) guests
  );
}
