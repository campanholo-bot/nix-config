{ pkgs, ... }:
{
  time.timeZone = "America/Sao_Paulo";

  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.channel.enable = false;
  nixpkgs.config.allowUnfree = true;
  programs.nh.clean = {
    enable = true;
    extraArgs = "--keep 4 --no-direnv";
  };

  # Programs
  environment.systemPackages = with pkgs; [
    git
    gh
    ripgrep
    jq
    python3
  ];
  programs.direnv.enable = true;

  # Accounts
  users.mutableUsers = false;
  users.users.isolino = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = "/etc/secrets/isolino-password-hash";
  };

  # Disk
  boot.initrd.luks.devices.crypted = {
    allowDiscards = true;
    crypttabExtraOpts = [ "tpm2-device=auto" ];
  };

  # Boot
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys.enable = true;
    configurationLimit = 4;
    # On by default; off so that nobody at the boot menu can edit the kernel command line.
    settings.editor = false;
  };

  # Snapshots
  services.snapper.configs.home = {
    SUBVOLUME = "/home";
    TIMELINE_CREATE = true;
    TIMELINE_CLEANUP = true;
    TIMELINE_LIMIT_HOURLY = 168;
    TIMELINE_LIMIT_DAILY = 0;
    TIMELINE_LIMIT_MONTHLY = 0;
    TIMELINE_LIMIT_YEARLY = 0;
  };
}
