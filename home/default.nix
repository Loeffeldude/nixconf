{ config, flake-inputs, ... }: {

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs.flake-inputs = flake-inputs;
  home-manager.users.loeffel = import ./home/home.nix;

  systemd.user.sessionVariables =
    config.home-manager.users.loeffel.home.sessionVariables;
}
