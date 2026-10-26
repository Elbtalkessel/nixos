{
  pkgs,
  ...
}:
{
  # https://wiki.nixos.org/wiki/AMD_GPU
  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
  };
  systemd.tmpfiles.rules =
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in
    [
      # HIP support for software that uses hard-coded libraries.
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
      # PyTorch does not show the the GPU model
      "L+    /opt/amdgpu/share/libdrm/amdgpu.ids   -    -    -     -    ${pkgs.libdrm}/share/libdrm/amdgpu.ids"
    ];
  nixpkgs.config.rocmSupport = true;
  # GUI: amdgpu controller.
  services.lact.enable = true;
}
