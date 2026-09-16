{ pkgs, config, self, lib, ... }: {
  imports = [ ../../modules/darwin ../../modules/home/darwin ];

  networking.hostName = "nicostartupwerk"; # Define your hostname.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;
  primaryUser = "nicokraetschmer";
  dev.enable = true;
  home-manager.users.nicokraetschmer.dev.enable = true;
  home-manager.users.nicokraetschmer.dev.ai.opencodeOverrides = {
    model = "github-copilot/gpt-5.6-terra";
    small_model = "github-copilot/gpt-5.6-luna";
    agent = {
      build.model = "github-copilot/gpt-5.6-sol";
      plan.model = "github-copilot/gpt-5.6-sol";
      general.model = "github-copilot/gpt-5.6-terra";
      explore.model = "github-copilot/gpt-5.6-luna";
    };
  };
  gaming.enable = false;
  apps.enable = true;

  services.openssh.enable = false;

  home-manager.users.nicokraetschmer.programs.git = {
    settings.user.name = lib.mkForce "Nico Krätschmer";
    settings.user.email = lib.mkForce "n.kraetschmer@linkvertise.com";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}






