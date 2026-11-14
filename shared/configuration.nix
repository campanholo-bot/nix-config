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
}
