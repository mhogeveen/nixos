{ config, lib, ... }:
{
  # the package, portal and FileManager1 service are system-side (hosts/common.nix);
  # this only makes strata the handler for folders (xdg-open on a directory)
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "io.github.lgse.Strata.desktop";
      # was already in the hand-made mimeapps.list (written by claude code); keep it
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
    };
  };

  # Cendre, written by the pyrrha shell (src/theme.rs) at launch and on every accent
  # change, so strata follows the shell's accent live; strata watches a link's target
  # folder
  xdg.configFile."strata/themes/cendre.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.xdg.stateHome}/pyrrha/strata-theme.toml";

  # strata owns settings.toml and rewrites it, so it can't be a store link. seed it
  # with the theme selection when it's missing; strata keeps unknown-to-it defaults
  # and only writes back keys that change, and a theme picked later is left alone
  home.activation.strataTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    f="${config.xdg.configHome}/strata/settings.toml"
    if [ ! -e "$f" ]; then
      run mkdir -p "$(dirname "$f")"
      run sh -c "printf 'mode = \"theme\"\ntheme = \"cendre\"\n' > \"$f\""
    fi
  '';
}
