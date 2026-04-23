{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.virtualisation.lookingGlass;
  lgUser = cfg.user;
in {
  options.virtualisation.lookingGlass = {
    enable = mkEnableOption "Looking Glass host-side setup";

    staticSizeMB = mkOption {
      type = types.int;
      default = 128;
      description = "KVMFR shared memory size in MiB.";
    };

    user = mkOption {
      type = types.str;
      default = config.primaryUser;
      description = "User that should own and access /dev/kvmfr0.";
    };

    clientPackage = mkOption {
      type = types.bool;
      default = true;
      description = "Install looking-glass-client in system packages.";
    };
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
    boot.kernelModules = [ "kvmfr" ];
    boot.extraModprobeConfig = ''
      options kvmfr static_size_mb=${toString cfg.staticSizeMB}
    '';

    services.udev.extraRules = ''
      SUBSYSTEM=="kvmfr", OWNER="${lgUser}", GROUP="kvm", MODE="0660"
    '';

    users.users.${lgUser}.extraGroups = [ "kvm" ];

    environment.systemPackages = mkIf cfg.clientPackage [
      pkgs.looking-glass-client
    ];
  };
}
