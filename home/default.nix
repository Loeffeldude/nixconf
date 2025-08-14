{ config, flake-inputs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs.flake-inputs = flake-inputs;
  home-manager.users.loeffel = import ./home.nix;

}
