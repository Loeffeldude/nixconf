{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.elixir;

in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      beamMinimal26Packages.erlang
      beamMinimal26Packages.elixir
    ];
  };
}
