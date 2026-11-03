{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # launcher
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
    yazi

    # screenshots
    grim
    slurp
  ];

  xdg.configFile."fuzzel".source = ../config/fuzzel/.config/fuzzel;
  xdg.configFile."mango".source = ../config/mango/.config/mango;
}
