{ config, lib, pkgs, ... }: {
  config.programs.pw-manager.pinentry = pkgs.pinentry;
}

