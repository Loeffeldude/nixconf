{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  config =
    mkIf cfg.enable {
      programs.neovim = {
        extraPackages = with pkgs; [
          # C#
          # roslyn-ls
          csharp-ls
          dotnet-sdk_9
          csharpier
        ];
      };
    };
}
