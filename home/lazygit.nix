{ config, ... }:
{
  programs.lazygit = {
    enable = true;

    settings = {
      # delta (delta.nix) renders the diffs, with the options from git config;
      # | switches to the side-by-side one when the panel is wide enough
      git.diffRenderers =
        map
          (args: {
            colorArg = "always";
            command = "${config.programs.delta.package}/bin/delta --paging=never${args}";
          })
          [
            ""
            " --side-by-side"
          ];

      # e opens the file in nvim at the selected line
      os.editPreset = "nvim";
      # straight back to lazygit after an editor or shell it started
      promptToReturnFromSubprocess = false;

      gui = {
        nerdFontsVersion = "3";
        showRandomTip = false;

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
