{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  config = mkIf cfg.enable {

    home.file.".gitignore".source = ../../configs/.gitignore.global;

    programs.git = {
      enable = true;
      settings = {
        user.name = "Loeffeldude";
        user.email = "kraetschmerni@gmail.com";
        column.ui = "auto";
        branch.sort = "version:refname";
        tag.sort = "version:refname";
        core.excludesFile = "~/.gitignore";
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
    };

    programs.delta.enable = true;
  };
}
