{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.node;

in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Node.js runtime and package managers
      nodejs_22
      yarn
      pnpm
      bun

      # Node.js dev tools
      nodePackages.ts-node
      nodePackages.nodemon
      nodePackages.pm2

      # Development servers and utilities
      nodePackages.serve
    ];
  };
}

