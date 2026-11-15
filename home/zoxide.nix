{ ... }:
{
  # a cd that remembers directories; no colours of its own, so no theme
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;

    # cd itself jumps to remembered directories (cdi picks one with fzf);
    # plain paths work as before
    options = [
      "--cmd"
      "cd"
    ];
  };
}
