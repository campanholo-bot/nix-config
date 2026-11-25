user:
{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  systemd.user.services."t3-${user}" = {
    description = "T3 Code server";
    wantedBy = [ "default.target" ];
    unitConfig.ConditionUser = user;
    # The default path would hide the user's own tools from T3's agents and terminals.
    enableDefaultPath = false;
    # Otherwise T3 downloads its own.
    environment.T3CODE_CLOUDFLARED_PATH = lib.getExe pkgs.cloudflared;
    serviceConfig = {
      # The unwrapped CLI: the wrapper adds unused providers and a second Claude Code.
      # The port is 3 followed by the user's uid.
      ExecStart = "${
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.t3code.unwrapped
      }/bin/t3 serve --host 127.0.0.1 --port 3%U";
      UMask = "0077";
      Restart = "on-failure";
      # T3 exits with 130 when stopped, which would leave the unit failed.
      SuccessExitStatus = 130;
    };
  };
}
