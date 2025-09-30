{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [ yt-dlp rbw ];

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
      "pinentry": "${pkgs.pinentry}/bin/pinentry",
      "client_cert_path": null
    }
  '';
}

