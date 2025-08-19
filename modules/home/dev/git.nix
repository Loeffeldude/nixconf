{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Loeffeldude";
      userEmail = "kraetschmerni@gmail.com";
      extraConfig = {
        column.ui = "auto";
        branch.sort = "version:refname";
        tag.sort = "version:refname";
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          memonicPrefix = true;
          renames = true;

        };
        init.defaultBranch = "main";
        pull.rebase = false;
        push = {
          default = "simple";
          autoSetupRemote = true;
        };
        help.autocorrect = true;
        commit.verbose = true;
        rebase = {
          autoSquash = true;
          autoStash = true;
          updateRefs = true;
        };
      };
      delta.enable = true;
    };
  };
}
