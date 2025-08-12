{ config, pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Loeffeldude";
    userEmail = "kraetschmerni@gmail.com";
  };
}
