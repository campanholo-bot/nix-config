{
  imports = [
    ./hardware-configuration.nix
    ./disk.nix
    ../../shared/configuration.nix
  ];

  networking.hostName = "MONSTRINHO";

  console.keyMap = "br-abnt2";

  zramSwap.enable = true;

  # Reboots when a new kernel or boot image needs it, only while nobody is working.
  system.autoUpgrade = {
    allowReboot = true;
    rebootWindow = {
      lower = "04:00";
      upper = "06:00";
    };
  };

  system.stateVersion = "26.11";
}
