# nix-config

NixOS configuration for two machines.

- **MONSTRAO**: a desktop with the niri Wayland session, dual-booting Windows 11.
- **MONSTRINHO**: a laptop run headless as a home server for two users.

The rules for changing this repo are in [CLAUDE.md](CLAUDE.md).

## Subscription proxy logins

The proxy's two Claude logins are made by hand, as isolino, on each machine.
Each ends about a month after it is made. Once per subscription:

    (umask 077 && cli-proxy-api -config /etc/cli-proxy-api/config.yaml -claude-login -no-browser)

Open the address it prints and sign in to that subscription within five
minutes. A browser on the same machine completes the login by itself. A
browser on another device ends on a `localhost:54545` page that does not load:
paste that page's address into the prompt the command shows.
The exit status does not show whether the login worked: only the last line,
"Claude authentication successful!", does.
