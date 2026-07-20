{ config, ... }:
let
  enable = (config.my.filesystem.exports |> builtins.length) > 0;
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
        config.my.filesystem.exports
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

    # The samba-wsdd service and avahi is used to advertise the shares to Windows hosts.
    samba-wsdd = {
      inherit enable;
      openFirewall = true;
    };

    avahi = {
      inherit enable;
      openFirewall = true;
      publish.enable = true;
      publish.userServices = true;
      # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
      nssmdns4 = true;
      # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
    };
  };
}
