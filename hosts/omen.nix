{
  lib,
  modulesPath,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # Mostly from https://github.com/NixOS/nixos-hardware/blob/master/omen/16-n0280nd/default.nix
    # The rest (kernel modules and prime config is in the omen.nix)
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    # Disable nvidia drivers:
    #   error: Package ‘nvidia-x11-560.35.03-6.12.1’ in /nix/store/*-source/pkgs/os-specific/linux/nvidia-x11/generic.nix:278 is marked as broken, refusing to evaluate.
    # I don't use descreet graphics anyway.'
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    ./omen-disko.nix
  ];

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "uas"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "sdhci_pci"
    ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [
      "kvm-amd"
      "hp-wmi"
    ];
    extraModulePackages = [ ];
    kernelParams = [
      # Two settings for AMD gpu I enabled after experienced lagging destop.
      # Probaby won't help, DC should be enabled automatically and PP isn't all that useful
      # on its own, imo.
      # Display Core: a new display engine providing modern features.
      "amdgpu.dc=1"
      # PowerPlay feature mask, all bit are set to 1 meaning overclocking, fan speed control and "Advanced power management features."
      "amdgpu.ppfeaturemask=0xffffffff"
    ];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.amd.updateMicrocode = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [ amdvlk ];
    };
    # Disable nvidia drivers, see above.
    nvidia = {
      open = false;
      prime = {
        amdgpuBusId = "PCI:7:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
