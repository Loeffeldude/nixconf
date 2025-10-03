{ config, pkgs, lib, ... }: {
  users.users.nicokratschmer = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
