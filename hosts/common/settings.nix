{ config, pkgs, ... }: {
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.variables = {
    EDITOR = "vim";
    PATH = [ "$HOME/.local/bin" ];
  };
}

