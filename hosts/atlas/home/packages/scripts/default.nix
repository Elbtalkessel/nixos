{ pkgs, ... }: {
  home.packages = [
    (pkgs.writeShellScriptBin "gidged" (builtins.readFile ./gidged.bash))
  ];
}
