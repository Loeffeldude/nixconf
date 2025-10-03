{ config, pkgs, lib, ... }: {

  options = {
    primaryUser = lib.mkOption {
      type = lib.types.str;
      description = "Primary username for the system";
      default = "loeffel";
    };
  };
  imports = [ ./settings.nix ./fonts.nix ./localization.nix ./user.nix ];
}
