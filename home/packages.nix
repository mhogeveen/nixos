{
  config,
  osConfig,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages = with pkgs; [
    # apps
    vlc
    pcmanfm

    # clipboard history, recorded and shown by the amane shell
    cliphist

    # notify-send; the amane shell itself is the notification daemon
    libnotify

    # cli
    fd
    gcc
    go
    jq
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

  xdg.configFile."amane".source =
    config.lib.file.mkOutOfStoreSymlink "${osConfig.user.flakeDir}/config/amane/.config/amane";
}
