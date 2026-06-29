{ config, lib, ... }:
let
  homeDir = config.home.homeDirectory;
in
{
  config = {
    sops = {
      defaultSopsFormat = lib.mkDefault "yaml";
      age.keyFile = lib.mkDefault "${homeDir}/.config/sops/age/keys.txt";
    };
  };
}
