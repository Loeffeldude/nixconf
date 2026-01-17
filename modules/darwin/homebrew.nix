{ config, flake-inputs, ... }:
{

  imports = [
    flake-inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = config.primaryUser;
  };

  homebrew = {
    enable = true;
    casks = [
      "taskbar"
      "alt-tab"
      "xquartz"
    ];
  };
}
