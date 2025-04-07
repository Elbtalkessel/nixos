{ pkgs, ... }:
{
  boot = {
    kernelModules = [
      "kvm-amd"
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];
    kernelParams = [
      "amd_iommu=on"
      "amd_iommu=pt"
      "kvm.ignore_msrs=1"
    ];
    extraModprobeConfig = "options vfio-pci ids=10de:249d,10de:228b";
  };
  # Add a file for looking-glass to use later. This will allow for viewing the guest VM's screen in a
  # performant way.
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 risus libvirtd -"
  ];
  environment.systemPackages = with pkgs; [
    looking-glass-client
  ];
}
