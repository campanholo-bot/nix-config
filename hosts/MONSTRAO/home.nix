{
  imports = [ ../../shared/home.nix ];

  # Session
  xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;
  xdg.configFile."mako/config".source = ./mako/config;

  home.stateVersion = "26.11";
}
