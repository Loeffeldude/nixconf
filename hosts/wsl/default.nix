{ flake-inputs, pkgs, lib, ... }: {
  imports = [
    flake-inputs.nixos-wsl.nixosModules.default
    ../../modules/home/nixos
    ../../modules/nixos
  ];
  wsl.enable = true;
  wsl.defaultUser = "nicokratschmer";
  wsl.docker-desktop.enable = true;

  services.flatpak.enable = lib.mkForce false;

  networking.hostName = "wsl";

  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  gaming.enable = lib.mkForce false;
  dev.enable = true;
  apps.enable = lib.mkForce false;
  desktop.gnome.enable = lib.mkForce false;

  networking.firewall.enable = false;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
