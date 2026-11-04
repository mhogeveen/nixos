{ ... }:
{
  programs.zsh = {
    enable = true;

    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 5000;
      save = 5000;
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
    };

    initContent = ''
      source ${../config/zsh/.config/zsh/prompt.zsh}
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
