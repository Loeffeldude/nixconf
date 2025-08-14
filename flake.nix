{
  description = "My NixOS configurations";

  inputs = {
    # we live on the edge man
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";
    # For macOS
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, ... }: {
    nixosConfigurations = {
      qemu = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { flake-inputs = inputs; };
        modules = [
          ./hosts/qemu/default.nix
          ./modules/basic-dev.nix
          ./modules/gnome.nix
          home-manager.nixosModules.home-manager
          import
          ./home/default.nix
        ];
      };

    };

  };
}
