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
    ollama.nvidia = lib.mkOption
      {
        type = lib.types.bool;
        default = false;
      };
  };
  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs.flake-inputs = flake-inputs;

      users.loeffel.options.ai = {
        enable = lib.mkDefault cfg.enable;
        ollama.enable = lib.mkOption {
          type = lib.types.bool;
          default = lib.mkDefault cfg.ollama.enable;
        };
      };
    };
  };
}
