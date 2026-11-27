{
  config,
  lib,
  pkgs,
  ...
}:
# Firmware for aic8800 wifi chips.
# Pending PR https://github.com/NixOS/nixpkgs/pull/443520
# Usage:
# {
#   imports = [
#     ../_shared/pkgs/firmware/aic8800.nix
#   ];
#   hardware.aic8800dc.enable = true;
# }
let
  cfg = config.hardware.aic8800dc;

  aic8800-src = pkgs.fetchFromGitHub {
    owner = "Kiborgik";
    repo = "aic8800dc-linux-patched";
    rev = "6ef22608cfb3a765783718926c08e28bde32c87f";
    hash = "sha256-j8Xrq/vBfoVP1anU7mmH6K0e30hTugNa2szMC9Jkc+o=";
  };

  aic8800-firmware = pkgs.stdenvNoCC.mkDerivation {
    pname = "aic8800-firmware";
    version = "1.0.0";
    src = aic8800-src;
    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/firmware
      cp -r fw/aic8800DC $out/lib/firmware/
      runHook postInstall
    '';
    # driver reads blobs directly (CONFIG_USE_FW_REQUEST unset) —
    # no compression, and kernel-modules path irrelevant, this is opened raw
    passthru.compressFirmware = false;
  };

  aic8800-kmodule = config.boot.kernelPackages.callPackage (
    {
      stdenv,
      kmod,
      kernel,
      kernelModuleMakeFlags,
    }:
    stdenv.mkDerivation {
      pname = "aic8800";
      version = "1.0.0";
      src = aic8800-src;
      sourceRoot = "source/drivers/aic8800";
      hardeningDisable = [ "all" ];
      nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;
      enableParallelBuilding = true;
      makeFlags = kernelModuleMakeFlags ++ [
        "KVER=${kernel.modDirVersion}"
        "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      ];
      # Route installation through the kernel's modules_install instead of
      # the vendor Makefile's file copy: this runs the module signing rule
      # (kmodigest), producing the .ko.cer files the NixOS module tree
      # build concatenates into modules.cer. The appended target is invoked
      # by the default install phase through installTargets, which passes
      # makeFlags (incl. cmd_sign) as proper argv entries.
      postPatch = ''
        # NixOS has no /lib/firmware; firmware lives behind the
        # /run/current-system/firmware symlink (and NixOS points the
        # kernel's firmware_class.path at a store path instead). The
        # driver opens firmware files directly, so it needs a real path.
        substituteInPlace aic_load_fw/aicbluetooth.c \
          --replace-fail '"/lib/firmware"' '"/run/current-system/firmware"'
        printf 'aic_install:\n\tmake -C $(KDIR) M=$(PWD) modules_install INSTALL_MOD_PATH=$(INSTALL_MOD_PATH)\n' >> Makefile
      '';
      installTargets = [ "aic_install" ];
      installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
      # depmod metadata would collide with the kernel's own modules tree
      # when boot.extraModulePackages merges them; ship only the modules
      # and their signing certs.
      postInstall = ''
        rm -f $out/lib/modules/${kernel.modDirVersion}/modules.*
      '';
    }
  ) { };
in
{
  options.hardware.aic8800dc = {
    enable = lib.mkEnableOption "AIC8800DC USB Wi-Fi 6 adapter driver";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      extraModulePackages = [ aic8800-kmodule ];
      kernelModules = [
        "aic_load_fw"
        "aic8800_fdrv"
      ];
      extraModprobeConfig = ''
        options aic_load_fw aic_fw_path=/run/current-system/firmware
      '';
    };
    hardware.firmware = [ aic8800-firmware ];
    # Both the loader and aic8800_fdrv take their firmware base from this
    # param when set (loader: flat dir + filename, fdrv: get_fw_path()).
    # Point it straight at the AIC8800DC firmware directory. For a
    # different AIC8800 variant, change the directory (or drop the line and
    # rely on the patched default path, which resolves the subdir by chip).
    services.udev.extraRules = ''
      # AIC8800 dongles enumerate as a write-protected "driver CD" USB mass
      # storage device first; ejecting that LUN makes the chip re-enumerate
      # in WLAN mode (a69c:8d80 "AIC Wlan").
      KERNEL=="sd*", ATTRS{idVendor}=="a69c", ATTRS{idProduct}=="5721", RUN+="${pkgs.eject}/bin/eject /dev/%k"
      KERNEL=="sd*", ATTRS{idVendor}=="a69c", ATTRS{idProduct}=="5721", RUN+="${pkgs.eject}/bin/eject /dev/%k"
      KERNEL=="sd*", ATTRS{idVendor}=="a69c", ATTRS{idProduct}=="5722", RUN+="${pkgs.eject}/bin/eject /dev/%k"
      KERNEL=="sd*", ATTRS{idVendor}=="a69c", ATTRS{idProduct}=="572a", RUN+="${pkgs.eject}/bin/eject /dev/%k"
    '';
  };
}
