{ config, pkgs, flake-inputs, lib, ... }:
with lib;
let cfg = config.ai;

in {


  imports = [
    ./ollama.nix
  ];

  options.ai = {
    enable = lib.mkEnableOption "enable ai";
    ollama.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    ollama.nvidia = libMkOption
      {
        type = lib.types.bool;
        default = false;
      };
  };
  config = mkIf cfg.enable { };
}
