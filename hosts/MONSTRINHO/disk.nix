{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-CL4-3D256-Q11_NVMe_SSSTC_256GB_TW0M3TJT9DH00268037P_1";
    content = {
      type = "gpt";
      partitions.ESP = {
        size = "1G";
        type = "EF00";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };
      partitions.luks = {
        size = "100%";
        content = {
          type = "luks";
          name = "crypted";
          content = {
            type = "btrfs";
            subvolumes = {
              root.mountpoint = "/";
              home.mountpoint = "/home";
              home-snapshots.mountpoint = "/home/.snapshots";
            };
          };
        };
      };
    };
  };
}
