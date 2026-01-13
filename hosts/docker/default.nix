{ config, pkgs, flake-inputs, ... }:

{
  imports = [
    ../../modules/shared
    flake-inputs.home-manager.nixosModules.home-manager
  ];

  boot.isContainer = true;

  networking.hostName = "nixos-container";
  networking.useDHCP = false;

  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    htop
    wget
    tmux
  ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  users.users.root.initialPassword = "nixos";

  users.users.${config.primaryUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
    group = "loeffel";
  };

  users.groups.${config.primaryUser} = {};

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { 
      flake-inputs = flake-inputs;
      upperConfig = config;
    };
    users.${config.primaryUser} = import ./home.nix;
  };

  system.stateVersion = "25.05";
}
