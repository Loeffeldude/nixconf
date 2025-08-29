{ config, lib, flake-inputs, ... }: {
  config = {
    imports = [ ./apps ./dev ./utilties.nix ];
  };
}
