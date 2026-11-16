{
  lib,
  pkgs,
  inputs,
  ...
}:
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
  programs.waybar.enable = true;
  security.soteria.enable = true;
  systemd.user.services.swayidle = {
    description = "Lock before suspend";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    requisite = [ "graphical-session.target" ];
    path = [ pkgs.swaylock ];
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.swayidle} -w before-sleep 'swaylock -f'";
      Restart = "on-failure";
    };
  };
  # Without it, dead keys do not compose in GTK 4 apps under niri.
  environment.sessionVariables.GTK_IM_MODULE = "simple";

  # Programs
  environment.systemPackages = with pkgs; [
    # niri starts it from the PATH when an X11 app connects.
    xwayland-satellite
    # Its packaged user service starts on the first notification.
    mako
    swaylock
    fuzzel
    ghostty
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium
    sioyek
    loupe
    mpv
    nautilus
    wl-clipboard
    playerctl
    pavucontrol
    # nixpkgs' comma has no package index; this one carries the prebuilt one.
    inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.comma-with-db
  ];
  programs.fish.enable = true;
  # Nautilus's trash and disk mounting.
  services.gvfs.enable = true;
  fonts.packages = [ pkgs.jetbrains-mono ];

  system.stateVersion = "26.11";
}
