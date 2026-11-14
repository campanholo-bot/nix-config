{
  imports = [
    ./hardware-configuration.nix
    ./disk.nix
    ../../shared/configuration.nix
  ];

  networking.hostName = "MONSTRINHO";

  console.keyMap = "br-abnt2";

  zramSwap.enable = true;

  system.stateVersion = "26.11";
}
