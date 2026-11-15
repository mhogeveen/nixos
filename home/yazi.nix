{ inputs, lib, ... }:
{
  programs.yazi = {
    enable = true;
    # `y` wrapper: runs yazi and cds into the folder you quit in
    enableZshIntegration = true;

    settings.mgr = {
      show_hidden = true;
      sort_dir_first = true;
      sort_by = "natural";
    };

    # cendre (hard), https://github.com/Aejkatappaja/cendre (extras/yazi/cendre.toml);
    # file previews use cendre's bat tmTheme, as the theme's header suggests
    theme = lib.recursiveUpdate (lib.importTOML "${inputs.cendre}/extras/yazi/cendre.toml") {
      mgr.syntect_theme = "${inputs.cendre}/extras/bat/cendre.tmTheme";
    };
  };
}
