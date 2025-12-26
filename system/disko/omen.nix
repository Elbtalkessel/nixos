{
  fileSystems = {
    "/mnt/storage" = {
      # Trying to resolve issue:
      #   /mnt/storage: fsconfig() failed: /dev/nvme0n1p2
      # UUID instead of LABEL. If won't help, try remove the commit opt,
      # (the default value is around 30 or 15 seconds afaik.)
      device = "/dev/disk/by-uuid/24bc5091-edd2-4209-b790-e1740a7a5ea1";
      fsType = "ext4";
      options = [
        "noatime"
        "commit=100"
        "nofail"
      ];
    };
  };

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {

            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            root = {
              end = "-32G";
              content = {
                type = "luks";
                name = "crypted";
                settings.allowDiscards = true;
                passwordFile = "/tmp/secret.key";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                  mountOptions = [
                    "defaults"
                    "noatime"
                  ];
                };
              };
            };

            swap = {
              size = "100%";
              content = {
                type = "swap";
                randomEncryption = true;
                resumeDevice = true;
              };
            };
          };
        };
      };
    };
  };
}
