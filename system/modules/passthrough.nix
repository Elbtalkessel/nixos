{ pkgs, config, ... }:
{
  # https://looking-glass.io/docs/B7/ivshmem_kvmfr/#loading
  # https://blog.redstone.engineer/posts/nixos-windows-guest-simple-looking-glass-setup-guide/
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
    kernelModules = [
      "kvmfr" # KVMFR for Looking Glass
      "kvm-amd" # AMD virtualization
      "vfio_pci" # PCI passthrough core
      "vfio" # VFIO framework
      "vfio_iommu_type1" # IOMMU Type1 support
    ];
    kernelParams = [
      "amd_iommu=on" # Enable AMD IOMMU
      "iommu=pt" # PASSTHROUGH mode (not amd_iommu=pt)
      "kvm.ignore_msrs=1" # Required for NVIDIA GPUs
    ];
    extraModprobeConfig = ''
      options kvmfr static_size_mb=32
      options vfio-pci ids=10de:249d,10de:228b
    '';
  };

  # https://looking-glass.io/docs/B7-rc1/ivshmem_kvmfr/#permissions
  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="${config.username}", GROUP="kvm", MODE="0660"
  '';
  users.users.${config.username}.extraGroups = [ "kvm" ];

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
