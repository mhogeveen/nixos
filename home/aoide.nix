{ config, inputs, ... }:
{
  imports = [ inputs.aoide.homeModules.default ];

  # the terminal music player: `aoide` opens the TUI and starts its daemon when
  # none runs; the daemon keeps playing after the TUI closes
  programs.aoide = {
    enable = true;

    # ~/.config/aoide/config.toml. no secrets in here: logins are done in the TUI
    # (:jellyfin login, :spotify login) and kept in ~/.local/state/aoide. the
    # daemon reads this at its start, so a change to a source needs `aoide restart`
    settings = {
      # the theme file linked below
      theme.theme = "cendre";

      # the sidebar shows them in this order
      source = [
        {
          type = "local";
          name = "Music";
          dirs = [ "~/Music" ];
        }
        {
          type = "radio";
          name = "Radio";
        }
        {
          type = "jellyfin";
          name = "Jellyfin";
          url = "https://jellyfin.welara-turtle.ts.net";
          user = "mhogeveen";
        }
        {
          type = "spotify";
          name = "Spotify";
          # the app registered in spotify's developer dashboard (a public id, not a
          # secret); bitrate = 320 would pick 96, 160 or 320 kbit/s
          client_id = "a9967a2055dd468287d15bca2945e132";
        }
      ];
    };
  };

  # Cendre, written by the pyrrha shell (src/theme.rs) at launch and on every accent
  # change, so a running aoide follows the shell's accent live; aoide watches the
  # link's target. not in programs.aoide.themes, which would write a fixed file
  xdg.configFile."aoide/themes/cendre.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.xdg.stateHome}/pyrrha/aoide-theme.toml";
}
