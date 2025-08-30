{ config, lib, flake-inputs, ... }: {
  imports = [ ./apps ./dev ./utilties.nix ];
  config = { };
}
