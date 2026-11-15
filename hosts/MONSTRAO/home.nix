{
  imports = [ ../../shared/home.nix ];

  # Session
  xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;

  home.stateVersion = "26.11";
}
