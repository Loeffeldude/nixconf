{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.csharp;

in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (with dotnetCorePackages; combinePackages [ sdk_8_0 sdk_9_0 ])
      mono
      nuget
      roslyn-ls
    ];

    home = {
      sessionPath = [ "$HOME/.dotnet/tools" "${pkgs.omnisharp-roslyn}" ];
      sessionVariables = { DOTNET_ROOT = "${pkgs.dotnet-sdk_8}"; };
    };
  };

}

