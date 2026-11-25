{
  imports = [
    ./hardware-configuration.nix
    ./disk.nix
    ../../shared/configuration.nix
  ];

  networking.hostName = "MONSTRINHO";

  home-manager.users.isolino = ./home.nix;

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

  # The machine
  # It runs headless with the lid closed.
  services.logind.settings.Login.HandleLidSwitch = "ignore";
  # Asleep, it is out of reach until someone opens the lid. It cannot hibernate:
  # it has no swap on disk.
  systemd.sleep.settings.Sleep.AllowSuspend = false;
  # The panel and its backlight go dark with the console.
  boot.kernelParams = [ "consoleblank=60" ];

  system.stateVersion = "26.11";
}
