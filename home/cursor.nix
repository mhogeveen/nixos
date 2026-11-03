{ pkgs, ... }:
{
  # Writes ~/.icons/default/index.theme (so wlroots' "default" lookup resolves
  # to Adwaita), sets the GTK cursor and exports XCURSOR_THEME/XCURSOR_SIZE.
  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
