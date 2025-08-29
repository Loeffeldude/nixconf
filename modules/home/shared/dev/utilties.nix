{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    openssl
    pre-commit

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
    iftop # network monitoring

  ];
}
