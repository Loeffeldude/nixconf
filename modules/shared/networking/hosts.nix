{ config, pkgs, lib, ... }:

{
  imports = [
  ];
  config = {
    services.resolved.enable = false;
    services.dnsmasq = {
      enable = true;
      settings = {
        address = "/lffl.internal/10.42.0.1";
        server = [ "8.8.8.8" "8.8.4.4" ];
      };
    };

    # Make sure local DNS is used first
    networking.nameservers = [ "127.0.0.1" ];

  };
}
