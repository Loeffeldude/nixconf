{ config, pkgs, lib, ... }: {

  config = let
    nvim-treesitter = pkgs.vimPlugins.nvim-treesitter;
    treesitterWithGrammars = nvim-treesitter.withAllGrammars;

    treesitter-parsers = pkgs.symlinkJoin {
      name = "treesitter-parsers";
      paths = treesitterWithGrammars.dependencies;
    };
  in {

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
      coc.enable = false;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;

      plugins = [ treesitterWithGrammars ];

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
        ripgrep
        # latex
        zathura
        biber
        # for lazy packages
        nodejs_latest
      ];
    };
  };

}
