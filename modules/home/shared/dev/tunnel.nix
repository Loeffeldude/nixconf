{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.boring;
  tomlFormat = pkgs.formats.toml { };

  tomlConfig = {
    tunnels = map
      (t:
        {
          inherit (t) name local remote host;
        }
        // lib.optionalAttrs (t.user != null) {
          user = t.user;
        }
        // lib.optionalAttrs (t.identity != null) {
          identity = t.identity;
        }
      )
      cfg.tunnels;
  };
in
{
  options.programs.boring = {
    enable = lib.mkEnableOption "boring";
    tunnels = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption { type = lib.types.str; };
          local = lib.mkOption { type = lib.types.str; };
          remote = lib.mkOption { type = lib.types.str; };
          host = lib.mkOption { type = lib.types.str; };

          user = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };

          identity = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
        };
      });

      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ boring ];

    xdg.configFile.".boring.toml".source =
      tomlFormat.generate ".boring.toml" tomlConfig;
  };
}
