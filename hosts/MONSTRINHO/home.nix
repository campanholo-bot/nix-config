{ inputs, ... }:
{
  imports = [
    ../../shared/home.nix
    inputs.rex.homeManagerModules.default
  ];

  # Git
  # MONSTRINHO has no GitHub SSH key, and gh's login works over HTTPS.
  programs.git.settings.url."https://github.com/".insteadOf = [
    "git@github.com:"
    "ssh://git@github.com/"
  ];

  # Rex
  services.rex = {
    enable = true;
    # The socket the tailnet publishing service serves at the bare host name.
    extraListen = [ "tailnet-serve:///run/user/1000/rex/serve.sock" ];
  };
  systemd.user.services.rex = {
    # Rex's module keeps the old server running after an update, until a restart by hand.
    Unit.X-SwitchMethod = "restart";
    Service.UMask = "0077";
  };

  home.stateVersion = "26.11";
}
