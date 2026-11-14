{
  imports = [
    ./hardware-configuration.nix
    ../../shared/configuration.nix
  ];

  networking.hostName = "MONSTRINHO";

  system.stateVersion = "26.11";
}
