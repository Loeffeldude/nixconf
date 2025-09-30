{ config, pkgs, lib, flake-inputs, ... }:

{
  imports = [
    flake-inputs.sops-nix.nixosModules.sops
  ];
  config = { };
}

