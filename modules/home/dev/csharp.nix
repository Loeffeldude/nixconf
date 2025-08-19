{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.csharp;

in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dotnet-sdk_7
      dotnet-sdk_8
      mono
      nuget
      nunit
      xunit
      msbuild
    ];
  };
}

