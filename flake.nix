{
  description = "My NixOS configurations";

  inputs = {
    # we live on the edge man
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, nixos-wsl, ... }: {
    nixosConfigurations = {
      qemu = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { flake-inputs = inputs; };
        modules = [ ./hosts/qemu/default.nix ];
      };

      t500 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { flake-inputs = inputs; };
        modules = [ ./hosts/t500/default.nix ];
      };

      t15 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          flake-inputs = inputs;
        };
        modules = [ ./hosts/t15/default.nix ];
      };
      ms7e57 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { flake-inputs = inputs; };
        modules = [ ./hosts/ms7e57/default.nix ];
      };
      wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { flake-inputs = inputs; };
        modules = [
          ./hosts/wsl
        ];
      };
    };
    darwinConfigurations =
      {
        vm = darwin.lib.darwinSystem
          {
            modules = [ ./hosts/darwin/vm.nix ];

            specialArgs = {
              flake-inputs = inputs;
              self = self;
            };
          };
      };
    # TODO: add homemanger config for home-manager only systems

    # homeManagerConfigurations = {
    #   "loeffel" = home-manager.lib.homeManagerConfiguration {
    #     pkgs = nixpkgs.legacyPackages."x86_64-linux";
    #     extraSpecialArgs = { flake-inputs = inputs; };
    #     modules = [ ./modules/home/default.nix ];
    #   };
    # };
  };
}
