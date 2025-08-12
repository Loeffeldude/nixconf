{ config, pkgs, ... }: {
  users.users.loeffel = {
    isNormalUser = true;
    description = "Nico";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };
}
