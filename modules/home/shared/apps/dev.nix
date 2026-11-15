{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let
  cfg = config.apps;
  ghidraMcp = pkgs.ghidra-extensions.callPackage flake-inputs.ghidra-mcp {
    # Upstream keeps the Maven dependency derivation private.
    stdenv = pkgs.stdenv // {
      mkDerivation = args: pkgs.stdenv.mkDerivation (args // lib.optionalAttrs (args.pname == "mcp-maven-deps") {
        outputHash = "sha256-E0EJnHHxADsYVrjv2R22OEWFnMsfYB1AJU0hoF4YcX4=";
      });
    };
  };
  stablePkgs = import flake-inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

in
{
  config = mkIf cfg.dev.enable {
    home.packages = with pkgs; [
      (ghidra.withExtensions (_: [ ghidraMcp ]))
      podman-desktop
      dbeaver-bin
      stablePkgs.bruno
    ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      jetbrains.rider
    ];

    home.file.".ideavimrc".source = ../../configs/.ideavimrc;
  };
}
