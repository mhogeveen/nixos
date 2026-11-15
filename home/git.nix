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
}
