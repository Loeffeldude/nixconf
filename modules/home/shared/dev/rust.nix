{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.rust;

in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cargo
      rustc
    ];

    home = {
      sessionPath = [ "$HOME/.cargo/bin" ];
      sessionVariables = {
        CARGO_HOME = "$HOME/.cargo";
        RUSTUP_HOME = "$HOME/.rustup";
      };
    };
  };
}
