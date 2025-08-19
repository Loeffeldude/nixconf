{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.csharp;

in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ dotnet-sdk_8 mono nuget omnisharp-roslyn ];

    home = {
      sessionPath = [ "$HOME/.dotnet/tools" "${pkgs.omnisharp-roslyn}" ];
      sessionVariables = { DOTNET_ROOT = "${pkgs.dotnet-sdk_8}"; };
    };
  };

}

