{ pkgs, ... }:
let
  tmsu = (
    pkgs.tmsu.overrideAttrs (oldAttrs: {
      postInstall = # bash
        ''
          ${oldAttrs.postInstall}
          cp misc/bin/tmsu-fs-* $out/bin/
        '';
    })
  );
in
{
  home.packages = [
    tmsu
    (pkgs.nuenv.writeShellApplication {
      name = "tag";
      text = builtins.readFile ./tag.nu;
      runtimeInputs = [
        pkgs.imagemagick
        tmsu
      ];
    })
  ];
}
