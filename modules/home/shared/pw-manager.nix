{ config, lib, pkgs, ... }:

{
  imports = [ ];

  options = {
    programs.pw-manager.pinentry = lib.mkOption {
      type = lib.types.oneOf [ lib.types.package lib.types.str ];
      description = "the pinentry command to use can also be a package";
      default = "pinentry";
    };
  };

  config =
    let
      cfg = config.programs.pw-manager;
      exportScript = pkgs.writeShellScriptBin "export-ssh-keys" ''
        if ! ${pkgs.rbw}/bin/rbw unlock >/dev/null 2>&1; then
          echo "Failed to unlock rbw"
          exit 1
        fi

        mkdir -p "$HOME/.ssh/bitwarden"
      
        ${pkgs.rbw}/bin/rbw list --raw | 
          ${pkgs.jq}/bin/jq -r '.[].id' | 
          while read -r id; do
            entry=$(${pkgs.rbw}/bin/rbw get --raw "$id")
            key=$(echo "$entry" | ${pkgs.jq}/bin/jq -r 'if .data.public_key then .data.public_key else empty end')
            name=$(echo "$entry" | ${pkgs.jq}/bin/jq -r '.name')
            if [ ! -z "$key" ]; then
              echo "$key" > "$HOME/.ssh/bitwarden/$name.pub"
            fi
          done
      '';
    in
    {
      home.packages = [ exportScript ] ++ (with pkgs; [
        yt-dlp
        rbw
      ]);

      home.file.".config/rbw/config.json".text = ''
        {
          "email": "kraetschmerni@gmail.com",
          "sso_id": null,
          "base_url": null,
          "identity_url": null,
          "ui_url": null,
          "notifications_url": null,
          "lock_timeout": 3600,
          "sync_interval": 3600,
          "pinentry": "${if lib.isString cfg.pinentry then cfg.pinentry else lib.getExe cfg.pinentry}",
          "client_cert_path": null
        }
      '';

      systemd.user.services.rbw-ssh-keys = {
        Unit = {
          Description = "Export Bitwarden SSH public keys";
          After = [ "rbw-sync.service" ];
        };

        Install = {
          WantedBy = [ "default.target" ];
        };

        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${exportScript}/bin/export-ssh-keys";
        };
      };
    };
}
