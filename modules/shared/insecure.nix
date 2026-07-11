{ config, pkgs, lib, flake-inputs, ... }: {
  nixpkgs.config.permittedInsecurePackages = [
    # add insecure packages here
  ];
}
