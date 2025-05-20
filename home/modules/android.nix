{ pkgs, ... }:
{
  home.packages = with pkgs; [
    scrcpy
    android-tools
    ripgrep
    # https://github.com/Genymobile/scrcpy/issues/2114
    # https://github.com/nikp123/scrcpy-desktop/blob/main/startscreen.sh
    (writeShellScriptBin "adb-desktop" (builtins.readFile ../bin/adb-desktop.sh))
  ];
}
