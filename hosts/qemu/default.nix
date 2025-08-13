# my bad laptop
{ config, pkgs, ... }:

{
  imports = [
    # generate using make file
    ./hardware-configuration.nix
    ../common/localization.nix
    ../common/settings.nix
    ../common/user.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "qemu";
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  # Disk is encrypted so we login automatically
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "loeffel";

  nixpkgs.config.allowUnfree = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

