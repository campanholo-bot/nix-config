{
  imports = [
    ./hardware-configuration.nix
    ./disk.nix
    ../../shared/configuration.nix
  ];

  networking.hostName = "MONSTRINHO";

  system.stateVersion = "26.11";
}
