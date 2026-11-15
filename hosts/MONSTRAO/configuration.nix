{ lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../shared/configuration.nix
  ];

  networking.hostName = "MONSTRAO";

  home-manager.users.isolino = ./home.nix;

  # Tailscale answers Taildrop inside its own process, where the firewall does not see it.
  services.tailscale.disableTaildrop = true;

  # Staged for the next boot, so the NVIDIA driver never changes under a running session.
  system.autoUpgrade.operation = "boot";

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

  # Hardware
  # NixOS switches the NVIDIA driver on through this list, though no X server runs.
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Blackwell cards are supported only by the open kernel module.
    open = true;
    powerManagement.enable = true;
    # On by default; nothing uses NVIDIA's settings app.
    nvidiaSettings = false;
  };
  services.pipewire.enable = true;
  security.rtkit.enable = true;
  programs.coolercontrol.enable = true;
  # Nothing loads the driver for the board's Nuvoton fan controller by itself.
  boot.kernelModules = [ "nct6775" ];

  # Session
  programs.niri.enable = true;
  # niri starts xwayland-satellite from the PATH when an X11 app connects.
  environment.systemPackages = [ pkgs.xwayland-satellite ];
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session.command = "${lib.getExe pkgs.tuigreet} --time --remember --background doom --asterisks --cmd niri-session";
  };
  console.font = "ter-v24b";
  console.packages = [ pkgs.terminus_font ];
  systemd.user.services.swaybg = {
    description = "Wallpaper";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    requisite = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.swaybg} --mode fill --image ${./monk-by-the-sea.jpg}";
      Restart = "on-failure";
    };
  };

  system.stateVersion = "26.11";
}
