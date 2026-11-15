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
      diff = {
        algorithm = "histogram";
        # moved blocks show as moves, not as a delete plus an add
        colorMoved = "default";
      };
      # conflict markers include the common ancestor; delta shows them 3-way
      merge.conflictStyle = "zdiff3";
    };
  };
}
