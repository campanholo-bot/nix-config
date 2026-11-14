{
  imports = [
    ./hardware-configuration.nix
    ./disk.nix
    ../../shared/configuration.nix
  ];

  networking.hostName = "MONSTRINHO";

  zramSwap.enable = true;

  system.stateVersion = "26.11";
}
