{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (tmsu.overrideAttrs (oldAttrs: {
      postInstall = # bash
        ''
          ${oldAttrs.postInstall}
          cp misc/bin/tmsu-fs-* $out/bin/
        '';
    }))
    (nuenv.writeShellApplication {
      name = "tag";
      text = builtins.readFile ./tag.nu;
    })
  ];
}
