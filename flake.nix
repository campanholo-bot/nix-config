{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }@inputs:
    {
      nixosConfigurations.MONSTRAO = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/MONSTRAO/configuration.nix ];
      };

      nixosConfigurations.MONSTRINHO = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/MONSTRINHO/configuration.nix ];
      };
    };
}
