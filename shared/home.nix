{ inputs, ... }:
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
      # What `gh auth setup-git` writes, which it cannot do in a read-only config.
      credential."https://github.com".helper = [
        ""
        "!/run/current-system/sw/bin/gh auth git-credential"
      ];
      credential."https://gist.github.com".helper = [
        ""
        "!/run/current-system/sw/bin/gh auth git-credential"
      ];
    };
    ignores = [ "**/.claude/settings.local.json" ];
  };

  # Claude Code
  home.file.".claude/settings.json".source = ./claude-code/settings.json;
  home.file.".claude/skills/mattpocock-skills".source = inputs.mattpocock-skills;
  home.file.".claude/skills/impeccable".source = "${inputs.impeccable}/plugin";

  # pi
  home.file.".pi/agent/settings.json".source = ./pi/settings.json;
}
