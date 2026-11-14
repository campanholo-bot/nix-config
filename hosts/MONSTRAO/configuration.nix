{
  imports = [
    ./hardware-configuration.nix
    ../../shared/configuration.nix
  ];

  networking.hostName = "MONSTRAO";

  # Disk
  # The partitions are made by hand beside Windows, and these names are given to them at install.
  boot.initrd.luks.devices.crypted.device = "/dev/disk/by-partlabel/nixos";
  fileSystems."/" = {
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };
  fileSystems."/home" = {
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };
  fileSystems."/home/.snapshots" = {
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    options = [ "subvol=home-snapshots" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/ESP";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  boot.lanzaboote.settings.reboot-for-bitlocker = true;

  system.stateVersion = "26.11";
}
