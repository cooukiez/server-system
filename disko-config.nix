{
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "table";
          format = "msdos";
          partitions = [
            {
              name = "zfs";
              start = "1M";
              end = "100%";
              part-type = "primary";
              bootable = true;
              content = {
                type = "zfs";
                pool = "zroot";
              };
            }
          ];
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";

        rootFsOptions = {
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };
        mountpoint = "/";
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";

        datasets = {
          "local" = {
            type = "zfs_dataset";
            mountpoint = "/local";
          };
          "local/nix" = {
            type = "zfs_dataset";
            mountpoint = "/nix";
          };
          "data" = {
            type = "zfs_dataset";
            mountpoint = "/data";
          };
        };
      };
    };
  };
}
