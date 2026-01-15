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
    go.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    rust.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    docker.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    k8s.enable = lib.mkOption {
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
    csharp.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
  imports = [
    # Tools
    ./git.nix
    ./neovim.nix
    ./zsh.nix
    ./terminal.nix
    ./ai.nix
    ./utilties.nix
    ./docker.nix
    ./k8s.nix
    # Langs
    ./go.nix
    ./csharp.nix
    ./node.nix
    ./reverse.nix
    # ./php.nix
    ./python.nix
    ./rust.nix
    # Other
    ./just.nix
    ./gamedev
  ];
}
