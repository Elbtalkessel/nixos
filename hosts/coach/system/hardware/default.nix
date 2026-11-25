{ pkgs, ... }:
{
  hardware = {
    cpu.intel.updateMicrocode = true;

    # Intel UHD 630 (Coffee Lake, Gen 9.5) — VA-API decode for H.264/H.265.
    # Kodi (GBM) and Moonlight both use it for hardware-accelerated playback.
    # No 32-bit libs: nothing on this box (Kodi, Moonlight, RetroArch) is
    # 32-bit, so we skip the multilib overhead Steam would force on us.
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # iHD — Gen 9.5+ (Coffee Lake) VA-API
      ];
    };

    # Bluetooth (USB dongle today, maybe the L440's wifi-bt card later) powers
    # Xbox controllers. xpadneo is the out-of-tree driver for Bluetooth Xbox
    # One/Series controllers; it forces bluetooth on itself, so the explicit
    # block is for powerOnBoot.
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    xpadneo.enable = true;
  };
}
