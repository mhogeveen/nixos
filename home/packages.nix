{ config, pkgs, ... }:
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
    btop

    # screenshots
    grim
    slurp
  ];

  xdg.configFile."fuzzel".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/config/fuzzel/.config/fuzzel";
  xdg.configFile."mango".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/config/mango/.config/mango";
}
