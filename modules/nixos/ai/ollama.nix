{ config, pkgs, flake-inputs, lib, ... }:
with lib;
let cfg = config.ai.ollama;

in {

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.ollama.override {
        acceleration =
          if cfg.nvidia then "cuda" else "rocm";
      })
    ];

    services.ollama = {
      enable = true;
      package =
        if cfg.nvidia then pkgs.ollama-cuda else pkgs.ollama-vulkan;
    };
  };
}
  
