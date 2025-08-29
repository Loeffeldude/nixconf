{ lib, ... }: {
  options.apps = {
    enable = lib.mkEnableOption "enable apps";
    social.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    dev.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    gaming.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    media.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    productivity.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    misc.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
}
