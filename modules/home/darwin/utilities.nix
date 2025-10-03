{ config, lib, pkgs, ... }:
{
  programs.pw-manager.pinentry = pkgs.pinentry_mac;
  home.file."/Users/${config.primaryUser}/Library/Application Support/rbw/config.json".text = config.home.file.".config/rbw/config.json".text;
}
