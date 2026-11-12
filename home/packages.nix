{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages = with pkgs; [
    # apps
    vlc
    pcmanfm

    # launcher
    fuzzel

    # clipboard history, recorded and shown by the amane shell
    cliphist

    # notify-send; the amane shell itself is the notification daemon
    libnotify

    # cli
    fd
    fzf
    gcc
    go
    jq
    lazygit
    nodejs
    opencode
    pkgs-unstable.claude-code
    ripgrep
    rustup
    unzip
    yazi
    btop
    rtk

    # screenshots and screen recordings (the shell's screenshot menu)
    grim
    slurp
    wf-recorder
  ];

  home.sessionPath = [ "${config.home.homeDirectory}/.cargo/bin" ];

  xdg.configFile."fuzzel".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/config/fuzzel/.config/fuzzel";
  xdg.configFile."mango".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/config/mango/.config/mango";
  xdg.configFile."amane".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/config/amane/.config/amane";
}
