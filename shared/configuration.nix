{ pkgs, inputs, ... }:
let
  llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  time.timeZone = "America/Sao_Paulo";

  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.channel.enable = false;
  # numtide's cache announces priority 30, ahead of the official cache's 40;
  # 50 asks it after.
  nix.settings.substituters = [ "https://cache.numtide.com?priority=50" ];
  nix.settings.trusted-public-keys = [
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
  ];
  nixpkgs.config.allowUnfree = true;
  programs.nh.clean = {
    enable = true;
    extraArgs = "--keep 4 --no-direnv";
  };

  # Nightly install
  system.autoUpgrade = {
    enable = true;
    # The branch is named so that the hosts never follow the repo's default branch.
    flake = "github:campanholo-bot/nix-config/main";
    # `--upgrade` updates root's channels, which a flake does not read.
    upgrade = false;
  };

  # Programs
  environment.systemPackages = with pkgs; [
    git
    gh
    ripgrep
    jq
    python3
    llm-agents.claude-code
    llm-agents.pi
  ];
  programs.direnv.enable = true;

  # Subscription proxy
  systemd.user.services.cli-proxy-api = {
    wantedBy = [ "default.target" ];
    unitConfig.ConditionUser = "isolino";
    serviceConfig = {
      ExecStart = "${llm-agents.cli-proxy-api}/bin/cli-proxy-api -config ${./cli-proxy-api/config.yaml}";
      UMask = "0077";
      Restart = "on-failure";
    };
  };
  # For the logins by hand (README.md). The service names the store path, so
  # that a changed file changes the unit and restarts it.
  environment.etc."cli-proxy-api/config.yaml".source = ./cli-proxy-api/config.yaml;
  users.users.isolino.packages = [ llm-agents.cli-proxy-api ];

  # Network
  services.tailscale.enable = true;
  # On iptables, Tailscale's own rule accepts all tailnet traffic ahead of the
  # firewall's; on nftables the firewall's rules also hold for the tailnet.
  networking.nftables.enable = true;
  # The router's IPv6 DNS proxy returns malformed replies to EDNS queries, and the
  # router cannot be configured: keep the IPv4 servers DHCPv4 hands out, and ignore
  # those from router advertisements (RDNSS) and DHCPv6.
  networking.dhcpcd.extraConfig = ''
    nooption nd_rdnss
    nooption dhcp6_name_servers
  '';

  # Accounts
  users.mutableUsers = false;
  users.users.isolino = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = "/etc/secrets/isolino-password-hash";
  };

  # Disk
  boot.initrd.luks.devices.crypted = {
    allowDiscards = true;
    crypttabExtraOpts = [ "tpm2-device=auto" ];
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

  # Snapshots
  services.snapper.configs.home = {
    SUBVOLUME = "/home";
    TIMELINE_CREATE = true;
    TIMELINE_CLEANUP = true;
    TIMELINE_LIMIT_HOURLY = 168;
    TIMELINE_LIMIT_DAILY = 0;
    TIMELINE_LIMIT_MONTHLY = 0;
    TIMELINE_LIMIT_YEARLY = 0;
  };
}
