{ config, lib, ... }:
let
  cfg = config.amd;
in {
  options.amd = {
    enable = lib.mkEnableOption "enable AMD GPU drivers";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    hardware.amdgpu.initrd.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
