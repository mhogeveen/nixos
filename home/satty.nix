{ config, ... }:
{
  programs.satty = {
    enable = true;

    settings = {
      general = {
        output-filename = "${config.home.homeDirectory}/Pictures/Screenshots/%Y%m%d%H%M%S.png";
        copy-command = "wl-copy";

        actions-on-enter = [ "save-to-clipboard" ];
        early-exit = true;
      };

      font.family = "BlexMono Nerd Font";
    };
  };
}
