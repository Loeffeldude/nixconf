{
  description = "My NixOS configurations";


  nixConfig = {
    trusted-substituters = [
      "https://cachix.cachix.org"
      "https://nixpkgs.cachix.org"
    ];
    trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    # we live on the edge man
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    homeManagerConfigurations = {
      "loeffel" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = { flake-inputs = inputs; };
        modules = [ ./modules/home/default.nix ];
      };
    };
  };
}
