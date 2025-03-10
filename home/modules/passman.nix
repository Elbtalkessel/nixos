{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gopass
    (pass.withExtensions (exts: [
      exts.pass-otp
      exts.pass-import
    ]))
  ];
}
