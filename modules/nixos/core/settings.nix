{ config, pkgs, ... }: {
  nix = {
    gc = {
      dates = "weekly";
    };
  };
}

