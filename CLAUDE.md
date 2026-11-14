# nix-config

Do what was asked, the way the official Nix manuals do it, and nothing more.
When these pull apart, the earlier one wins.

- What was asked: declared in the right place, and confirmed working by using it.
- The manuals' way: the official Nix manuals and nixpkgs conventions. Where they
  are silent, match what this repo already does. Where the repo is silent too,
  stop and ask, with a recommendation.
- Nothing more: every line serves a request, an abstraction arrives with the host
  that needs it, and a guard or test answers a threat the owner has named.

## Where a declaration goes

- One host has it: that host's directory under `hosts/`.
- Both hosts have it with the same value: `shared/`. With different values, each
  host's file states its own.
- Every declaration is unconditional: a file states what its host, or both
  hosts, get. An option of our own, an enable flag or a branch on the host name
  arrives with the host that needs it.
- `mkForce` and `mkDefault` override a nixpkgs default that a request requires
  changing. Between two files of this repo, move the declaration instead.
- `configuration.nix` holds everything NixOS: installed programs, every service,
  every account. `home.nix` holds how the owner's programs look and behave, and
  Home Manager lists the owner alone. Home Manager installs or runs a program in
  two cases: its plugins are inseparable from its settings, or the program ships
  its own Home Manager module.
- A program's settings are a plain file in the program's own format, in a
  directory named after the program beside the `home.nix` that places it. Home
  Manager's typed options are for a module that does more than write a file, or
  a value that differs between hosts.
- Each directory has one `configuration.nix` and one `home.nix`, split into
  areas by short comment headings (`# Network`, `# Accounts`). A heading covers
  several declarations. Any other comment gives a reason the code cannot show:
  the fault a workaround fixes, why a default is overridden, where a value comes
  from. A separate file exists when a tool generates it, another tool reads it,
  it is applied more than once, it is in another program's format, a declaration
  points to it, or it packages a program no input provides.

## Changing the config

A local tree is only ever passed to `test`. A host installs `main` alone: at
night, or at once with `sudo systemctl start nixos-upgrade`.

1. Start from the current `main` of `origin`; the lock file moves there daily.
2. Format the Nix files you touched with `nixfmt`.
3. Build every host the change touches. A file under `shared/` touches both.
4. Check the change yourself as far as you can: a VM of the host needs no sudo.
   What only the VM needs comes from an uncommitted file,
   `~/nix-config-vm.nix`: a module that sets the owner's `password` and sets his
   `hashedPasswordFile` to `lib.mkVMOverride null`. Without the second line the
   VM boots with his account locked.
   `nix build --impure --expr '((builtins.getFlake (toString ./.)).nixosConfigurations.<HOST>.extendModules { modules = [ ~/nix-config-vm.nix ]; }).config.system.build.vm' && QEMU_KERNEL_PARAMS=console=ttyS0 ./result/bin/run-<HOST>-vm -nographic`
5. Commit on `main` of the clone, and push nothing.
6. Ask the owner for one trial on each host the change touches:
   `sudo nixos-rebuild test --flake .`
   - From a T3 terminal on MONSTRINHO, start it through `systemd-run`, so a T3
     restart cannot kill it.
   - On MONSTRAO, first compare the built system's kernel and NVIDIA driver with
     the booted ones. If they differ, the owner reboots before the trial.
   - The trial is skipped only when the built system has the same store path as
     the running one.
7. After the trial, check the live host yourself and leave to the owner only
   what needs eyes.
8. Report three lists: what you ran and saw, what you could not verify and why,
   and what the owner must look at.
9. The owner lands the commit: he pushes it from the clone to `main` of
   `origin` with sudo, using the push key in `/etc/secrets`. Only that key can
   update `main`, so there is no pull request.

A change to the boot path (bootloader, boot image, disk unlock, kernel
parameters, snapshot layout) shows nothing in a trial. Say so in the report; it
is confirmed at the next boot after landing. MONSTRAO starts every landed change
at its next boot.

This file changes only in commits of its own.
