{ config, pkgs, lib, ... }: {
  users.users.${config.primaryUser} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
