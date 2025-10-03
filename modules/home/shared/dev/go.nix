{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.go;

in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go
    ];

    home = {
      sessionPath = [ "$HOME/go/bin" ];
      sessionVariables = {
        GOPATH = "$HOME/go";
      };
    };
  };

}
