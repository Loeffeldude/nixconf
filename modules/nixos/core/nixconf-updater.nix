{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.nixconf-updater;

  updateScript = pkgs.writeShellScript "nixconf-update-checker" ''
    # Find the nixconf repo by looking for flake.nix and checking if it's a git repo
    REPO_DIR=""
    
    # Check common locations
    for dir in "/home/nicokratschmer/nixconf" "/etc/nixos" "$(pwd)" "$HOME/.config/nixos" "$HOME/nixos-config"; do
        if [ -d "$dir/.git" ] && [ -f "$dir/flake.nix" ]; then
            # Verify this is actually the nixconf repo by checking for our modules
            if [ -d "$dir/modules/nixos/core" ]; then
                REPO_DIR="$dir"
                break
            fi
        fi
    done
    
    # If not found in common locations, search from root
    if [ -z "$REPO_DIR" ]; then
        REPO_DIR=$(${pkgs.findutils}/bin/find /home -name "flake.nix" -type f 2>/dev/null | \
                   ${pkgs.findutils}/bin/xargs -I {} dirname {} | \
                   while read dir; do
                       if [ -d "$dir/.git" ] && [ -d "$dir/modules/nixos/core" ]; then
                           echo "$dir"
                           break
                       fi
                   done | head -1)
    fi
    
    if [ -z "$REPO_DIR" ]; then
        echo "Error: Could not find nixconf repository"
        exit 1
    fi
    
    REMOTE_NAME="origin"
    REMOTE_BRANCH="main"
    
    cd "$REPO_DIR" || exit 1
    
    # Verify this is the expected nixconf repository
    REMOTE_URL=$(${pkgs.git}/bin/git remote get-url "$REMOTE_NAME" 2>/dev/null)
    EXPECTED_URLS=(
        "git@github.com:Loeffeldude/nixconf.git"
        "https://github.com/Loeffeldude/nixconf.git"
        "https://github.com/Loeffeldude/nixconf"
    )
    
    URL_MATCH=false
    for expected in "''${EXPECTED_URLS[@]}"; do
        if [ "$REMOTE_URL" = "$expected" ]; then
            URL_MATCH=true
            break
        fi
    done
    
    if [ "$URL_MATCH" = false ]; then
        echo "Warning: Remote origin URL ($REMOTE_URL) does not match expected nixconf repository"
        exit 0
    fi
    
    ${pkgs.git}/bin/git fetch "$REMOTE_NAME" &>/dev/null
    
    LOCAL_COMMIT=$(${pkgs.git}/bin/git rev-parse HEAD)
    REMOTE_COMMIT=$(${pkgs.git}/bin/git rev-parse "$REMOTE_NAME/$REMOTE_BRANCH")
    
    if [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
        TERMINAL_CMD="${pkgs.wezterm}/bin/wezterm start --always-new-process"
        
        $TERMINAL_CMD -- bash -c "
            echo 'NixConf Update Available!'
            echo '=================================='
            echo
            echo 'Changes available:'
            ${pkgs.git}/bin/git --git-dir='$REPO_DIR/.git' --work-tree='$REPO_DIR' log --oneline HEAD..$REMOTE_NAME/$REMOTE_BRANCH
            echo
            echo 'Detailed diff:'
            ${pkgs.git}/bin/git --git-dir='$REPO_DIR/.git' --work-tree='$REPO_DIR' diff HEAD..$REMOTE_NAME/$REMOTE_BRANCH --stat
            echo
            echo '=================================='
            echo
            read -p 'Do you want to update your nixconf? [y/N]: ' choice
            case \"\$choice\" in
                y|Y|yes|YES )
                    echo 'Updating nixconf...'
                    cd '$REPO_DIR'
                    ${pkgs.git}/bin/git pull '$REMOTE_NAME' '$REMOTE_BRANCH'
                    echo 'Running make...'
                    ${pkgs.gnumake}/bin/make
                    echo 'Update completed!'
                    read -p 'Press Enter to close...'
                    ;;
                * )
                    echo 'Update cancelled.'
                    read -p 'Press Enter to close...'
                    ;;
            esac
        "
    fi
  '';
in
{
  options.services.nixconf-updater = {
    enable = mkEnableOption "NixConf update checker";
  };

  config = mkIf cfg.enable {
    systemd.services.nixconf-updater = {
      description = "Check for NixConf updates";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "nicokratschmer";
        Group = "users";
        ExecStart = "${updateScript}";
        WorkingDirectory = "/home/nicokratschmer/nixconf";
        Environment = [ "DISPLAY=:0" ];
      };
    };
  };
}

