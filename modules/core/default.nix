{ config, pkgs, ... }: {
  imports = [ ./settings.nix ./fonts.nix ./localization.nix ./user.nix ];
}
