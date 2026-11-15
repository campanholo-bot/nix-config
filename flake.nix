{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.lanzaboote = {
    url = "github:nix-community/lanzaboote/v1.2.0";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Not following nixpkgs: numtide's cache holds these packages built against its own.
  inputs.llm-agents.url = "github:numtide/llm-agents.nix";

  outputs =
    {
      nixpkgs,
      lanzaboote,
      disko,
      ...
    }@inputs:
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
          disko.nixosModules.disko
          ./hosts/MONSTRINHO/configuration.nix
        ];
      };
    };
}
