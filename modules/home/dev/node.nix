{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.node;

in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Node.js runtime and package managers
      nodejs_22
      nodejs_20
      nodejs_18
      npm
      yarn
      pnpm
      bun

      # Node.js dev tools
      nodePackages.typescript
      nodePackages.ts-node
      nodePackages.tsx
      nodePackages.nodemon
      nodePackages.pm2

      # Linting and formatting
      nodePackages.eslint
      nodePackages.prettier
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted

      # Testing and build tools
      nodePackages.jest
      nodePackages.webpack
      nodePackages.webpack-cli
      nodePackages.vite
      nodePackages.rollup

      # Package management utilities
      nodePackages.npm-check-updates
      nodePackages.npm-check

      # Development servers and utilities
      nodePackages.serve
      nodePackages.http-server
      nodePackages.live-server
    ];
  };
}

