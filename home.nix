{ config, pkgs, ... }:

{
  home.username = "maarten";
  home.homeDirectory = "/home/maarten";
  programs.git = {
    enable = true;
    settings = {
      user = {
	name = "Maarten Hogeveen";
	email = "mhogeveen94@gmail.com";
      };
    };
  };
  home.stateVersion = "26.05";

  programs.zsh = {
    enable = true;

    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    history = {
      append = true;
      expireDuplicatesFirst = true;
      findNoDups = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      saveNoDups = true;
      save = 5000;
      share = true;
      size = 5000;
    };
    syntaxHighlighting.enable = true;
    shellAliases = {
      "ls" = "eza -a";
      "-- -" = "cd -";
      "c" = "clear";
      "lg" = "lazygit";
      "n" = "nvim";
      "e" = "exit";
      "nrs" = "sudo nixos-rebuild switch --flake 'git+file:///home/maarten/.nixos?submodules=1#prometheus'";
    };
    initContent = ''
      source ~/.nixos/config/zsh/.config/zsh/prompt.zsh
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

  home.file.".config/nvim".source = ./config/neovim/.config/nvim;
}
