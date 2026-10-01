{ pkgs, ... }:
{
  # Works well, but requires to keep rev up-to-date.
  # Seems like a chore, plus hyprland checks plugin version and
  # repo may not have a tag for a specific hyprland relase (
  # for example 0.55.3). Can be automated, I guess difference in patch
  # version should not be a problem, version is read from the VERSION file.
  wayland.windowManager.hyprland = {
    plugins = [
      (pkgs.callPackage (pkgs.fetchFromGitHub {
        owner = "sandwichfarm";
        repo = "hyprexpo";
        rev = "v0.55.2+2";
        sha256 = "sha256-E+yK/HwvUOrmrFwq/i9WuIpd/NC/qE2xYAwOV2RNp3o=";
      }) { })
    ];
    extraLuaFiles = {
      "hyprland.100-hyprexpo" = {
        content = ./hyprexpo.lua;
        autoLoad = true;
      };
    };
  };
}
