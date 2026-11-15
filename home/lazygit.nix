{ config, ... }:
{
  programs.lazygit = {
    enable = true;

    settings = {
      # delta (delta.nix) renders the diffs, with the options from git config
      git.diffRenderers = [
        {
          colorArg = "always";
          command = "${config.programs.delta.package}/bin/delta --paging=never";
        }
      ];

      gui = {
        nerdFontsVersion = "3";

        # cendre (hard), https://github.com/Aejkatappaja/cendre; the same
        # palette as foot.nix
        theme = {
          activeBorderColor = [
            "#ea9875"
            "bold"
          ];
          inactiveBorderColor = [ "#73665b" ];
          searchingActiveBorderColor = [
            "#fcba81"
            "bold"
          ];
          optionsTextColor = [ "#ea9875" ];
          selectedLineBgColor = [ "#2a2422" ];
          inactiveViewSelectedLineBgColor = [ "#201b19" ];
          cherryPickedCommitFgColor = [ "#171311" ];
          cherryPickedCommitBgColor = [ "#ea9875" ];
          markedBaseCommitFgColor = [ "#171311" ];
          markedBaseCommitBgColor = [ "#fcba81" ];
          unstagedChangesColor = [ "#d25780" ];
          defaultFgColor = [ "#e6d5c2" ];
        };
      };
    };
  };
}
