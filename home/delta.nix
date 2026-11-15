{ inputs, ... }:
{
  # syntax-highlighted diffs, as git's pager; the options land in git config's
  # [delta] section, so lazygit's delta (lazygit.nix) uses them too
  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      dark = true;
      line-numbers = true;
      # n and N jump between files in the pager
      navigate = true;

      # cendre (hard), https://github.com/Aejkatappaja/cendre
      syntax-theme = "cendre";
      minus-style = "syntax #301d1b";
      minus-emph-style = "syntax bold #362f2c";
      plus-style = "syntax #202515";
      plus-emph-style = "syntax bold #362f2c";
      hunk-header-style = "#a09384 italic";
      hunk-header-decoration-style = "#362f2c box";
      file-style = "#4e89a2 bold";
      file-decoration-style = "#4e89a2 ul";
      line-numbers-minus-style = "#d25780";
      line-numbers-plus-style = "#43b16a";
      line-numbers-zero-style = "#4e4641";
      line-numbers-left-style = "#4e4641";
      line-numbers-right-style = "#4e4641";
      commit-decoration-style = "#ea9875 box";
      commit-style = "#fcba81 bold";
      blame-palette = "#171311 #201b19 #2a2422 #362f2c";
    };
  };

  # delta's syntax-theme comes from bat's theme cache; home-manager runs
  # `bat cache --build` on activation to add this one
  programs.bat = {
    enable = true;
    themes.cendre = {
      src = inputs.cendre;
      file = "extras/bat/cendre.tmTheme";
    };
  };
}
