{ pkgs, ... }:
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
  services.upower = {
    enable = true;
    criticalPowerAction = "PowerOff";
  };
  # No desktop starts it, so it would otherwise never see the battery run down.
  systemd.services.upower.wantedBy = [ "multi-user.target" ];
  services.fwupd.enable = true;
  environment.systemPackages = [ pkgs.ghostty.terminfo ];
  # Browsers that tools download (T3's Chrome, Playwright, Puppeteer) are generic
  # Linux binaries.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      glib
      nspr
      nss
      dbus
      at-spi2-core
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxcb
      libxkbcommon
      libgbm
      expat
      alsa-lib
      fontconfig
      freetype
      cairo
      pango
      cups
    ];
  };

  # Accounts
  users.users.lavietos = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJU9VqlHeLAvukPFLKW8vN4BedMxQBasFvn6JYD4NCZe"
    ];
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      # Off the public IPv6 address, which leaves SSH to the LAN and the tailnet. This
      # line comes before the `AddressFamily any` that NixOS writes, and sshd takes
      # the first.
      AddressFamily = "inet";
    };
  };

  system.stateVersion = "26.11";
}
