{ pkgs, config, ... }:
{
  # https://looking-glass.io/docs/B7/ivshmem_kvmfr/#loading
  # https://blog.redstone.engineer/posts/nixos-windows-guest-simple-looking-glass-setup-guide/
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
    kernelModules = [
      "kvmfr" # KVMFR for Looking Glass
    ];
    extraModprobeConfig = ''
      options kvmfr static_size_mb=32
    '';
  };

  # https://looking-glass.io/docs/B7-rc1/ivshmem_kvmfr/#permissions
  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="${config.my.username}", GROUP="kvm", MODE="0660"
  '';

  # https://looking-glass.io/docs/B7-rc1/ivshmem_kvmfr/#cgroups
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    cgroup_device_acl = [
      "/dev/null",
      "/dev/full",
      "/dev/zero",
      "/dev/random",
      "/dev/urandom",
      "/dev/ptmx",
      "/dev/kvm",
      "/dev/kvmfr0"
    ]
  '';

  environment.systemPackages = with pkgs; [
    looking-glass-client
  ];
}
