{
  pkgs,
  config,
  lib,
  ...
}:
let
  tmsu = pkgs.tmsu.overrideAttrs (oldAttrs: {
    postInstall = # bash
      ''
        ${oldAttrs.postInstall}
        cp misc/bin/tmsu-fs-* $out/bin/
      '';
  });
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
        name =
          "tmsu-"
          + (
            mapping.src
            |> lib.removeSuffix "/"
            |> lib.removePrefix "/"
            |> lib.replaceString "/" "-"
          );
        # Tmsu creates symlinks relative to location of the database,
        # so it has to reside on the src level.
        db = "${mapping.src}/.tmsu/db";
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
            ExecStart =
              pkgs.writeShellScript "${name}-mount" # bash
                ''
                  ${lib.getExe tmsu} -D ${db} mount ${mapping.dst}
                '';
            ExecStop =
              pkgs.writeShellScript "${name}-unmount" # bash
                ''
                  "${lib.getExe tmsu} unmount ${mapping.dst}"
                '';
            TimeoutStartSec = 10;
            TimeoutStopSec = 5;
            MemoryMax = "512M";
            MemoryHigh = "400M";
            CPUQuota = "50%";
            TasksMax = "100";
            IOWeight = "50";
          };
          Unit = {
            Description = "TMSU mount of ${mapping.src} to ${mapping.dst}";
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
