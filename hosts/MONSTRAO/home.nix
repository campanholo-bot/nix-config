{ pkgs, ... }:
{
  imports = [ ../../shared/home.nix ];

  # Session
  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
  xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;
  xdg.configFile."mako/config".source = ./mako/config;
  xdg.configFile."swaylock/config".source = ./swaylock/config;
  xdg.configFile."fuzzel/fuzzel.ini".source = ./fuzzel/fuzzel.ini;

  # Programs
  xdg.configFile."ghostty/config.ghostty".source = ./ghostty/config.ghostty;
  xdg.configFile."fish/config.fish".source = ./fish/config.fish;
  xdg.configFile."sioyek/prefs_user.config".source = ./sioyek/prefs_user.config;
  xdg.configFile."mimeapps.list".source = ./mimeapps.list;

  # Emacs
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs: [
      epkgs.solarized-theme
      epkgs.evil
      epkgs.evil-collection
      epkgs.envrc
      epkgs.lsp-mode
      epkgs.tuareg
      (epkgs.callPackage ./lean4-mode.nix { })
      epkgs.markdown-mode
    ];
  };
  xdg.configFile."emacs/init.el".source = ./emacs/init.el;

  # Neovim
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = [ (pkgs.callPackage ./selenized.nix { }) ];
    # The module writes init.lua itself, with lines of its own, so the file is read into it.
    initLua = builtins.readFile ./nvim/init.lua;
  };

  # Fonts and theme
  xdg.configFile."fontconfig/fonts.conf".source = ./fontconfig/fonts.conf;
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  xdg.configFile."environment.d/qt.conf".source = ./environment.d/qt.conf;

  home.stateVersion = "26.11";
}
