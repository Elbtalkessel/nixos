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

  # Loads module `module` located in `subdir` under the `rootdir`.
  # Returns attribute set { <module name> = <module content> }
  # Conditionally namespaces the module name if it located in a directory
  # (excluding the root `./modules` directory.)
  # Example:
  #   loadModule ./modules "custom" sep.nix
  #   > { "custom/sep" = ''a string content returned by sep.nix call''; }
  #   loadModule ./modules "." tray.nix
  #   > { "tray" = ''a string content returned by calling the tray.nix''; }
  loadModule = (
    rootdir: subdir: module:
    let
      name = (lib.removeSuffix ".nix" module);
      pfx = if subdir != "modules" then "${subdir}/" else "";
    in
    {
      name = "${pfx}${name}";
      value = (
        import "${rootdir}/${subdir}/${module}" {
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
  # Builds an attribute set for *.nix files in a given `subdir` under the
  # `rootdir`.
  # Example:
  #   buildModuleAttrSet ./. "modules"
  #   > { backlight = ''content''; "custom/sep" = ''content''; }
  buildModuleAttrSet = (
    rootdir: subdir:
    _.readDir "${rootdir}/${subdir}"
    |> lib.filterAttrs (k: _: lib.hasSuffix ".nix" k)
    |> lib.attrNames
    |> map (loadModule rootdir subdir)
    |> lib.listToAttrs
  );
  # Builds an attribute set for *.nix files located under the `rootdir`/`subdir`/`subssubdir`.
  # Convoluted, but easier to read than recursion and we'll never have more than 1 level deep nesting.
  buildSubmoduleAttrSet = (
    rootdir: subdir:
    _.readDir "${rootdir}/${subdir}"
    |> lib.filterAttrs (_: v: v == "directory")
    |> lib.attrNames
    |> map (dir: buildModuleAttrSet "${rootdir}/${subdir}" dir)
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
        # Dynamic module import, any *.nix under then "./modules" file will be imported and exectued.
        # For "./modules/<name>.nix" attribute name will be "<name>",
        # and for "./modules/subdir/<name>.nix", attribute name will be "<subdir>/<name>".
        # Example, to customize "pulseaudio", drop "pulseaudio.nix" inside the "./modules" directory.
        # Note: the module should export a function,
        # the function should accept (or ignore) arguments defined in the `loadModule` above.
        #
        # TODO: what about importing only those defined in `modules-*` (if exist)?
        // (buildModuleAttrSet ./. "modules")
        // (buildSubmoduleAttrSet ./. "modules")
      )
    ];
  };
}
