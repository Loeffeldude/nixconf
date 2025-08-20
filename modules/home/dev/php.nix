{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.php;

in {

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # PHP runtime and versions
      php83

      # PHP package manager
      php83Packages.composer

      # PHP dev tools
      php83Packages.phpstan
      php83Packages.psalm
      php83Packages.php-cs-fixer
      php83Packages.php-codesniffer

      # PHP debugging and profiling
      php83Extensions.xdebug

      # Development servers
      php83Extensions.opcache

      # Database extensions
      php83Extensions.pdo
      php83Extensions.pdo_mysql
      php83Extensions.pdo_pgsql
      php83Extensions.mysqli
      php83Extensions.pgsql

      # Common PHP extensions
      php83Extensions.curl
      php83Extensions.gd
      php83Extensions.zip
      php83Extensions.xml
      php83Extensions.mbstring
      php83Extensions.openssl
    ];
  };
}
