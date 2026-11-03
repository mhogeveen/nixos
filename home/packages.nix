{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # terminals / launcher
    ghostty
    alacritty
    fuzzel

    # cli
    fd
    fzf
    gcc
    go
    jq
    lazygit
    nodejs
    opencode
    ripgrep
    unzip

    # screenshots
    grim
    slurp
  ];

  xdg.configFile."fuzzel".source = ../config/fuzzel/.config/fuzzel;
}
