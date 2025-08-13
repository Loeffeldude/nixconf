{ config, pkgs, flake-inputs, ... }: {
  imports = [
    # Import the nix-flatpak NixOS module and install applications system wide.
    # HomeManager users should import `${nix-flatpak}/modules/home-manager.nix`
    # where appropriate
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak

    ./default.nix
    ./dev.nix
    ./m.spotify.Client
    ","
    ./gaming.nix
    ./media.nix
    ./misc.nix
    ./productivity.nix
    ./social.nix
  ];

  # Configure nix-flatpak
  services.flatpak = {
    enable = true;
    packages = [ "org.mozilla.firefox" ];
  };

  home.packages = with pkgs; [
    obsidian
    spotify
    signal-desktop
    protonvpn-gui
    qbittorrent
  ];
}
