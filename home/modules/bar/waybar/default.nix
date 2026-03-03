{
  lib,
  config,
  ...
}:
let
  sep = "  ";
  lpad = v: if lib.stringLength v > 0 then sep + v else v;
  enable = config.my.wm.bar.provider == "waybar";
  _ = builtins;

  # Reads content of a directory and calls exported function inside of found *.nix file.
  # Isn't recursive but clean, afaik waybar only use <name> or <namespace>/<name> anyway.
  callFunc = (
    d: sd: v:
    let
      name = (lib.removeSuffix ".nix" v);
      pfx = if sd != "modules" then "${sd}/" else "";
    in
    {
      name = "${pfx}${name}";
      value = (
        import "${d}/${sd}/${v}" {
          inherit
            sep
            lpad
            lib
            config
            ;
        }
      );
    }
  );
  dirToAttrs = (
    d: sd:
    _.readDir "${d}/${sd}"
    |> lib.attrNames
    |> lib.filter (lib.hasSuffix ".nix")
    |> map (callFunc d sd)
    |> lib.listToAttrs
  );
  subdirsToAttrs = (
    d: sd:
    _.readDir "${d}/${sd}"
    |> lib.filterAttrs (_: v: v == "directory")
    |> lib.attrNames
    |> map (subdir: dirToAttrs "${d}/${sd}" subdir)
    |> lib.mergeAttrsList
  );
in
{
  programs.waybar = lib.mkIf enable {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    style = import ./style.nix { inherit config; };
    settings = [
      (
        {
          "layer" = "top";
          "position" = "bottom";
          "mode" = "dock";
          "exclusive" = true;
          "passthrough" = false;
          "gtk-layer-shell" = true;
          "height" = 0;
          "margin-top" = 5;
          "margin-left" = 5;
          "margin-right" = 5;
          "margin-bottom" = 3;
          "modules-left" = [
            "hyprland/workspaces"
            "custom/sep"
            "clock"
          ];
          "modules-center" = [
            "hyprland/window"
            "custom/sep"
          ];
          "modules-right" = [
            "tray"
            "custom/sep"
            "pulseaudio"
            # "mpd"
            "custom/sep"
            "network"
            # these may or may not be visible, separator is inside these.
            "bluetooth"
            "battery"
            "backlight"
            # ---
            "custom/sep"
            "hyprland/language"
          ];
        }
        // (dirToAttrs ./. "modules")
        // (subdirsToAttrs ./. "modules")
      )
    ];
  };
}
