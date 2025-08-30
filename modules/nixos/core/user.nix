{ config, pkgs, lib, ... }: {
  users.users.loeffel = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
