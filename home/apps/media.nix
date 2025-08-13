{ config, pkgs, flake-inputs, ... }: {
  services.flatpak = {
    enable = true;
    packages =
      [ "com.spotify.Client" "com.obsproject.Studio" "org.videolan.VLC" ];
  };
}
