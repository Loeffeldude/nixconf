{ config, lib, pkgs, ... }:
{
  home.file."~/.config/karabiner/karabiner.json".source = ../configs/karabiner.json;
}
