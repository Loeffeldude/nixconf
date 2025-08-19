{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  options.dev = {
    enable = mkEnableOption "enable dev";
    ai.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    python.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    node.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    php.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
  imports = [ ./git.nix ./neovim.nix ./shell.nix ./terminal.nix ./ai.nix ];
}
