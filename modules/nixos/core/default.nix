{ config, pkgs, ... }: {
  imports = [ ./localization.nix ./ld.nix ./user.nix ./settings.nix ];
}
