{ ... }:
{
  imports = [
    ./cursor.nix
    ./foot.nix
    ./git.nix
    ./gtk.nix
    ./hypridle.nix
    ./neovim.nix
    ./packages.nix
    ./qutebrowser.nix
    ./satty.nix
    ./zsh.nix
  ];

  home.username = "maarten";
  home.homeDirectory = "/home/maarten";

  home.stateVersion = "26.05";
}
