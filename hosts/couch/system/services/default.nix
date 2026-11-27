{
  services = {
    # The operator controls the box over SSH; nothing else opens a port.
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    # couch.local discovery.
    avahi.enable = true;

    # HDMI audio. Kodi (GBM) talks to it through the PulseAudio shim; Moonlight
    # and RetroArch (separate sessions) use it too. Switch to ALSA-direct only
    # if an AVR needs bitstream passthrough.
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    evremap = {
      enable = true;
      settings = {
        device_name = "HAOBO Technology USB Composite Device Keyboard";
        device_phys = "usb-0000:00:14.0-2/input2";
        remap = [
          {
            input = [ "KEY_SELECT" ];
            output = [ "KEY_ENTER" ];
          }
        ];
      };
    };
  };
}
