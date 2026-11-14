{
  time.timeZone = "America/Sao_Paulo";

  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.channel.enable = false;
  nixpkgs.config.allowUnfree = true;

  # Accounts
  users.mutableUsers = false;
  users.users.isolino = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = "/etc/secrets/isolino-password-hash";
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
}
