{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.dev.csharp;

  dotnet = pkgs.dotnetCorePackages.combinePackages [
    pkgs.dotnetCorePackages.sdk_8_0
    pkgs.dotnetCorePackages.sdk_9_0
    pkgs.dotnetCorePackages.sdk_10_0
  ];
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dotnet
      mono
      nuget
    ];

    home = {
      sessionPath = [ "$HOME/.dotnet/tools" ];

      sessionVariables = {
        DOTNET_ROOT = "${dotnet}/share/dotnet";
      };
    };
  };
}
