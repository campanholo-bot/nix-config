{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.lanzaboote = {
    url = "github:nix-community/lanzaboote/v1.2.0";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, lanzaboote, ... }@inputs:
    {
      nixosConfigurations.MONSTRAO = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          lanzaboote.nixosModules.lanzaboote
          ./hosts/MONSTRAO/configuration.nix
        ];
      };

      nixosConfigurations.MONSTRINHO = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          lanzaboote.nixosModules.lanzaboote
          ./hosts/MONSTRINHO/configuration.nix
        ];
      };
    };
}
