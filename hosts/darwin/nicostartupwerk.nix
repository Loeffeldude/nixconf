{ pkgs, config, self, lib, ... }: {
  imports = [ ../../modules/darwin ../../modules/home/darwin ];

  networking.hostName = "nicostartupwerk"; # Define your hostname.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;
  primaryUser = "nicokratschmer";
  dev.enable = true;
  home-manager.users.nicokratschmer.dev.enable = true;
  gaming.enable = false;
  apps.enable = true;

  services.openssh.enable = false;

  home-manager.users.nicokratschmer.programs.git = {
    userName = lib.mkForce "Nico Krätschmer";
    userEmail = lib.mkForce "nico@startup-werk.de";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}







