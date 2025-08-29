{ pkgs, self, ... }: {
  environment.systemPackages =
    [
      pkgs.vim
    ];

  imports = [ ../../modules/home/darwin ];

  networking.hostName = "vm"; # Define your hostname.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}







