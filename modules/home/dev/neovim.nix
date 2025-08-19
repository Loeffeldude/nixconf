{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  config = let
    nvim-treesitter = pkgs.vimPlugins.nvim-treesitter;
    treesitterWithGrammars = nvim-treesitter.withAllGrammars;

    treesitter-parsers = pkgs.symlinkJoin {
      name = "treesitter-parsers";
      paths = treesitterWithGrammars.dependencies;
    };
  in mkIf cfg.enable {

    home.file.".config/nvim" = {
      source = ../configs/nvim;
      recursive = true;
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };

    xdg.configFile."nvim/lua/parsers.lua".text = # lua
      ''
        vim.opt.runtimepath:append ("${treesitter-parsers}")
      '';

    programs.neovim = {
      enable = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;

      extraPackages = with pkgs; [
        marksman
        nil
        nixpkgs-fmt
        rustup
        lua-language-server
        fzf
        stylua
        taplo
        gnumake
        zig
        gcc
        clang-tools
        arduino-language-server
        arduino-cli
        coreutils
        wget
        fd
        luarocks-nix
        imagemagick
        # latex
        zathura
        biber
        # for lazy packages
        nodejs_latest

        # Rust
        rust-analyzer
        rustfmt
        clippy

        # Go
        gopls
        go
        golangci-lint

        # JavaScript/TypeScript
        nodejs_latest
        nodePackages.typescript-language-server
        nodePackages.eslint
        nodePackages.prettier

        # Python
        python311Packages.python-lsp-server
        black
        isort
        mypy
        pylint

        # PHP
        nodePackages.intelephense
        php82Packages.phpstan
        php82Packages.psalm
        php82Packages.composer
        php82Packages.php-cs-fixer

        # Web
        vscode-langservers-extracted
        nodePackages.stylelint

        # Markdown
        marksman

        # Nix
        nil
        nixpkgs-fmt
        statix

        # JSON
        nodePackages.vscode-json-languageserver
        jq

        # Additional utilities
        fzf
        ripgrep
      ];

      plugins = with pkgs.vimPlugins; [
        # LSP
        nvim-lspconfig
        null-ls-nvim
        trouble-nvim

        # Completion
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        luasnip
        cmp_luasnip
        # Telescope for fuzzy finding
        telescope-nvim
        telescope-fzf-native-nvim

        # Treesitter
        treesitterWithGrammars

        # Theme and UI
        tokyonight-nvim
        lualine-nvim
        nvim-web-devicons
      ];
    };
  };

}
