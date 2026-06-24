{
  lib,
  ...
}:
{
  hardware = {
    graphics.enable = lib.mkDefault true;
    graphics.enable32Bit = lib.mkDefault true;
  };
}
