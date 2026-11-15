{ osConfig, ... }:
{
  programs.zsh = {
    enable = true;

    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      share = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };

    historySubstringSearch = {
      enable = true;
      searchDownKey = "^n";
      searchUpKey = "^p";
    };

    shellAliases = {
      "ls" = "eza -a";
      "-- -" = "cd -";
      "c" = "clear";
      "lg" = "lazygit";
      "n" = "nvim";
      "e" = "exit";
      "nrs" = "nh os switch";
      # update every flake input, then rebuild
      "nfu" = "nh os switch --update";
    };

    # read from the checkout at runtime (not a store copy), so prompt edits
    # apply in new shells without a rebuild, like the other dotfiles
    initContent = ''
      source ${osConfig.user.flakeDir}/config/zsh/.config/zsh/prompt.zsh
    '';
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
