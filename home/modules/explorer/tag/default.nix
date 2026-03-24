{
  pkgs,
  config,
  lib,
  ...
}:
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
        pkgs.ffmpeg
        tmsu
      ];
    })
  ];
  systemd.user.services = lib.listToAttrs (
    map (
      mapping:
      let
        name = "tmsu-${lib.removeSuffix "/" (baseNameOf mapping.src)}";
      in
      {
        inherit name;
        value = {
          Install = {
            WantedBy = [ "default.target" ];
          };
          Service = {
            Type = "forking";
            RemainAfterExit = "yes";
            ExecStart = "${lib.getExe tmsu} -D ${mapping.src}/.tmsu/db mount ${mapping.dst}";
            ExecStop = "${lib.getExe tmsu} unmount ${mapping.dst}";
            TimeoutStartSec = 10;
            TimeoutStopSec = 5;
          };
          Unit = {
            Description = "TMSU ${mapping.src}:${mapping.dst}";
            ConditionPathIsDirectory = [
              mapping.src
              mapping.dst
            ];
          };
        };
      }
    ) config.my.filesystem.tagged.mounts
  );
}
