{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Maarten Hogeveen";
        email = "mhogeveen94@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rerere.enabled = true;
      diff.algorithm = "histogram";
    };
  };

  # syntax-highlighted diffs, as git's pager
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
