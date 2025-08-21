{ config, pkgs, flake-inputs, lib, ... }:
with lib;
let cfg = config.ai.ollama;

in {

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      acceleration =
        if cfg.nvidia then "cuda" else "rocm";
      loadModels = [ "gpt-oss:20b" "deepseek-r1:8b" ];
    };
  };
}
