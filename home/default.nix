{ ... }:
{
  imports = [
    ./cursor.nix
    ./foot.nix
    ./git.nix
    ./hypridle.nix
    ./zsh.nix
    ./neovim.nix
    ./packages.nix
    ./qutebrowser.nix
  ];

  home.username = "maarten";
  home.homeDirectory = "/home/maarten";

  home.stateVersion = "26.05";
}
