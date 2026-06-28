{ config, lib, flake-inputs, ... }: {
  imports = [ ./apps ./dev ./sops.nix ./utilties.nix ];
  config = { };
}
