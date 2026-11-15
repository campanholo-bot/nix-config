{
  # Git
  programs.git = {
    enable = true;
    # NixOS installs Git for every user.
    package = null;
    settings = {
      user.name = "Enzo L. Campanholo";
      user.email = "199099542+enzo-campanholo@users.noreply.github.com";
      init.defaultBranch = "main";
    };
    ignores = [ "**/.claude/settings.local.json" ];
  };
}
