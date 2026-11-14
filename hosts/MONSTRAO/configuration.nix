{
  imports = [
    ./hardware-configuration.nix
    ../../shared/configuration.nix
  ];

  networking.hostName = "MONSTRAO";

  system.stateVersion = "26.11";
}
