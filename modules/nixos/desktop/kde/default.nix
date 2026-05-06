{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.desktop.kde;
  plasmaI3SessionScript = pkgs.writeShellScriptBin "startplasma-i3" ''
    export PATH=${lib.makeBinPath [ pkgs.i3 ]}:$PATH
    export KDEWM=i3
    exec ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11
  '';
  plasmaI3Session = pkgs.symlinkJoin {
    name = "plasma-i3-session";
    passthru.providedSessions = [ "plasma-i3" ];
    paths = [
      plasmaI3SessionScript
      (pkgs.writeTextDir "share/xsessions/plasma-i3.desktop" ''
        [Desktop Entry]
        Type=XSession
        Exec=${plasmaI3SessionScript}/bin/startplasma-i3
        TryExec=${plasmaI3SessionScript}/bin/startplasma-i3
        DesktopNames=plasma-i3
        Name=Plasma + i3
      '')
    ];
  };
in
{
  options.desktop.kde = {
    enable = mkEnableOption "enable kde with i3";
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        xkb = {
          layout = "de";
          variant = "";
          options = "caps:escape";
        };

        windowManager.i3 = {
          enable = true;
          extraPackages = with pkgs; [
            i3lock
            i3status
          ];
        };
      };

      desktopManager.plasma6.enable = true;
      displayManager = {
        defaultSession = "plasma-i3";
        sessionPackages = [ plasmaI3Session ];
      };

      displayManager.sddm = {
        enable = true;
        wayland.enable = false;
      };

      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          naturalScrolling = true;
          middleEmulation = true;
          accelProfile = "adaptive";
        };
      };

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      power-profiles-daemon.enable = true;
      upower.enable = true;
    };

    security.rtkit.enable = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    networking.networkmanager = {
      enable = true;
      wifi.powersave = true;
    };

    environment.systemPackages = with pkgs; [
      feh
      picom
      wmctrl
      xclip
      xorg.xprop
      xorg.xwininfo
      networkmanagerapplet
      blueman
      pavucontrol
      kdePackages.spectacle
      playerctl
    ];

    home-manager.users.${config.primaryUser} = {
      desktop.kde.enable = true;
    };
  };
}
