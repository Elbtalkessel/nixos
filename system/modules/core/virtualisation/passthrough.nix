{
  config,
  lib,
  ...
}:
let
  enable = config.my.hardware.dgpu.enable && config.my.hardware.dgpu.passthrough;
in
{
  # https://looking-glass.io/docs/B7/ivshmem_kvmfr/#loading
  # https://blog.redstone.engineer/posts/nixos-windows-guest-simple-looking-glass-setup-guide/
  boot = lib.mkIf enable {
    kernelModules = [
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
      options vfio-pci ids=10de:249d,10de:228b
    '';
  };
}
