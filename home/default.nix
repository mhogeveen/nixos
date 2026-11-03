{ ... }:
{
  imports = [
    ./git.nix
    ./zsh.nix
    ./neovim.nix
    ./packages.nix
  ];

  home.username = "maarten";
  home.homeDirectory = "/home/maarten";

  home.stateVersion = "26.05";
}
