{
  description = "a koala's flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }:
    let
      system = "x86_64-linux";
    in {

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.default
          ./profiles/hyprland/configuration.nix
        ];
      };

    };
}
