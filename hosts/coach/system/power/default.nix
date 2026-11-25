# Idle-power tuning for a 24/7 appliance on an i3-9100T (Coffee Lake desktop).
{
  powerManagement = {
    # "powersave" is the balanced HWP governor (schedutil-equivalent) under
    # intel_pstate active mode; schedutil is NOT exposed there.
    cpuFreqGovernor = "powersave";

    # powertop auto-tune: USB/PCI runtime PM, SATA link PM — the main idle win
    # on a desktop with no battery.
    powertop.enable = true;
  };

  services = {
    # Thermal safety net for a sealed always-on box.
    thermald.enable = true;

    # Periodic TRIM; a continuous `discard` mount option is the wrong tool on NVMe.
    fstrim.enable = true;

    # Couch behaviour: "24/7" means "always available", not "never sleeps".
    # Suspend-to-RAM after 45 min of idle; the power key or air-mouse resumes.
    # Drop the IdleAction lines if the box must never sleep.
    logind.settings.Login = {
      HandlePowerKey = "suspend";
      IdleAction = "suspend";
      IdleActionSec = "45min";
    };
  };

  boot = {
    kernelParams = [
      # PCIe ASPM: force past the BIOS/FADT "not supported" declaration, then
      # powersave policy (L0s/L1 only). NOT powersupersave — L1 substates have
      # a real NVMe drop-off/data-loss history. If the box hangs at boot, drop
      # this line and boot a previous generation.
      "pcie_aspm=force"
      "pcie_aspm.policy=powersave"

      # i915 Frame Buffer Compression — cuts refresh memory bandwidth on HDMI.
      "i915.enable_fbc=1"
    ];

    # Batch dirty-page writeback to cut NVMe wakeups.
    kernel.sysctl = {
      "vm.dirty_writeback_centisecs" = 1500;
      "vm.dirty_expire_centisecs" = 6000;
    };
  };

  # TODO once the G10S air-mouse dongle arrives: keep it always-on while the
  # rest autosuspends (powertop sets every device to `auto`). Get the IDs from
  # `lsusb`, then:
  #
  #   services.udev.extraRules = ''
  #     ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="XXXX", ATTR{idProduct}=="YYYY", TEST=="power/control", ATTR{power/control}="on"
  #   '';
}
