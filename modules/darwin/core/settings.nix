{ config, pkgs, ... }: {
  nix = {
    gc = {
      interval = "weekly";
    };
  };
}

