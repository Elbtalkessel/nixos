{ config, ... }:
let
  enable = (config.my.core.filesystem.exports |> builtins.length) > 0;
in
{
  # TODO: untested.
  services = {
    samba = {
      inherit enable;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
      }
      // (
        config.my.core.filesystem.exports
        |> builtins.filter (a: a.protocol == "cifs")
        |> builtins.foldl' (
          acc: elem:
          {
            "${elem.path}" = {
              "path" = elem.path;
              "browseable" = "yes";
              "read only" = "no";
              "guest ok" = if elem.auth then "no" else "yes";
              "create mask" = "0644";
              "directory mask" = "0755";
              "hosts allow" = elem.allow;
              "hosts deny" = elem.deny;
            };
          }
          // acc
        ) { }
      );
    };
  };
}
