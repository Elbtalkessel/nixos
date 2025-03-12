{ pkgs, ... }:
{
  # Can't get gopass bridge to work, it doesn't find anything.
  home.packages = with pkgs; [
    gopass
    (pass.withExtensions (exts: [
      exts.pass-otp
      exts.pass-import
    ]))
  ];
}
