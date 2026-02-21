{
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "table";
          format = "msdos"; # This is the MBR requirement
          partitions = {
            # In MBR, we define partitions as an attribute set
            primary = {
              size = "100%";
              part-type = "primary";
              bootable = true;
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        datasets = {
          "root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options."com.sun:auto-snapshot" = "true";
          };
          # This is your requested data subvolume
          "data" = {
            type = "zfs_fs";
            mountpoint = "/data";
          };
        };
      };
    };
  };
}
