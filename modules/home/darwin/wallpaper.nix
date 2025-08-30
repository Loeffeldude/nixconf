{ config, pkgs, lib, ... }:
with lib;
let
  wallpaperScript = pkgs.writeScriptBin "set-wallpaper" ''
    #!${pkgs.stdenv.shell}
    /usr/bin/osascript -e 'tell application "Finder" to set desktop picture to POSIX file "'"$1"'"'
  '';
  homeDir = config.home.homeDirectory;
in
{

  home.file.".background-image-dark".source = ../../../media/nix-dark.png;
  home.file.".background-image-bright".source = ../../../media/nix-bright.png;

  home.packages = [ wallpaperScript ];

  # Auto-set wallpaper on activation
  home.activation = {
    setWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${wallpaperScript}/bin/set-wallpaper ${homeDir}/.background-image-dark
    '';
  };
}
