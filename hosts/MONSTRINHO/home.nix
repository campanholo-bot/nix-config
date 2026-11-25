{
  imports = [ ../../shared/home.nix ];

  # Git
  # MONSTRINHO has no GitHub SSH key, and gh's login works over HTTPS.
  programs.git.settings.url."https://github.com/".insteadOf = [
    "git@github.com:"
    "ssh://git@github.com/"
  ];

  home.stateVersion = "26.11";
}
