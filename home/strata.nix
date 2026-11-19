{ config, ... }:
{
  # the package, portal and FileManager1 service are system-side (hosts/prometheus);
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
  # folder. strata owns settings.toml, so it's selected there (theme = "cendre")
  xdg.configFile."strata/themes/cendre.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.xdg.stateHome}/pyrrha/strata-theme.toml";
}
