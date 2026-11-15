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

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Not following nixpkgs: numtide's cache holds these packages built against its own.
  inputs.llm-agents.url = "github:numtide/llm-agents.nix";

  inputs.mattpocock-skills = {
    url = "github:mattpocock/skills";
    flake = false;
  };

  inputs.impeccable = {
    url = "github:pbakaus/impeccable";
    flake = false;
  };

  outputs =
    {
      nixpkgs,
      lanzaboote,
      disko,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.MONSTRAO = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
          ./hosts/MONSTRAO/configuration.nix
        ];
      };

      nixosConfigurations.MONSTRINHO = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          lanzaboote.nixosModules.lanzaboote
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
          ./hosts/MONSTRINHO/configuration.nix
        ];
      };
    };
}
