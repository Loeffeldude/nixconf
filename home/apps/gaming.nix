{ config, pkgs, flake-inputs, ... }: {
  services.flatpak = {
    enable = true;
    packages = [ "org.desmume.DeSmuME" ];
  };

}
