{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "reverse-tunnel" ''
      #!/usr/bin/env bash

      PORT=''${1:-80}

      trap 'kill %1 %2; exit' SIGINT

      # Main tunnel
      ssh -o ServerAliveInterval=60 -R 10.42.42.1:8690:127.0.0.1:$PORT -N loeffelmeister.de &

      # Monitor connections (updates every 2 seconds)
      while true; do
          clear
          echo "Reverse Tunnel Active https://reverse.lffl.me"
          echo "Current connections:"
          netstat -tn | grep ":$PORT "
          sleep 2
      done &

      wait
    '')
  ];
}

