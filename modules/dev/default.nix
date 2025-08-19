{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  options.dev = { enable = mkEnableOption "enable dev"; };
  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      # archives
      zip
      xz
      unzip
      p7zip
      # utils
      gnumake
      fzf # A command-line fuzzy finder

      # networking tools
      mtr # A network diagnostic tool
      iperf3
      dnsutils # `dig` + `nslookup`
      ldns # replacement of `dig`, it provide the command `drill`
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc # it is a calculator for the IPv4/v6 addresses

      # misc
      cowsay
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd
      gnupg

      htop
      iotop # io monitoring
      iftop # network monitoring

      # system call monitoring
      strace # system call monitoring
      ltrace # library call monitoring
      lsof # list open files

      # system tools
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb
      xclip
    ];

    home-manager.users.loeffel = {
      dev.enable = true;
      apps = {
        enable = true;
        dev.enable = true;
      };
    };
  };

}
