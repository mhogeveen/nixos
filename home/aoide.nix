{
  config,
  inputs,
  pkgs,
  ...
}:
let
  # ~/.config/aoide/config.toml. the daemon reads it at its start, so a change to
  # a source needs `aoide restart`. logins are done in the TUI (:jellyfin login,
  # :spotify login) and kept in ~/.local/state/aoide
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
        # the server's address and the user stay out of this repository
        # (secrets/secrets.yaml)
        url = config.sops.placeholder."aoide/jellyfin_url";
        user = config.sops.placeholder."aoide/jellyfin_user";
      }
      {
        type = "spotify";
        name = "Spotify";
        # the app registered in spotify's developer dashboard, kept out of this
        # repository too; bitrate = 320 would pick 96, 160 or 320 kbit/s
        client_id = config.sops.placeholder."aoide/spotify_client_id";
      }
    ];
  };
in
{
  imports = [ inputs.aoide.homeModules.default ];

  # the terminal music player: `aoide` opens the TUI and starts its daemon when
  # none runs; the daemon keeps playing after the TUI closes. programs.aoide.settings
  # stays empty: it would write config.toml to the nix store, secrets and all
  programs.aoide.enable = true;

  # config.toml with the secrets filled in: sops-nix (home/sops.nix) renders the
  # template at login and on every switch, and config.toml links to the result.
  # before the secrets are decrypted the link points nowhere, and aoide starts
  # with its default sources
  sops.secrets = {
    "aoide/jellyfin_url" = { };
    "aoide/jellyfin_user" = { };
    "aoide/spotify_client_id" = { };
  };
  sops.templates."aoide-config.toml".file =
    (pkgs.formats.toml { }).generate "aoide-config.toml"
      settings;
  xdg.configFile."aoide/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink
      config.sops.templates."aoide-config.toml".path;

  # Cendre, written by the pyrrha shell (src/theme.rs) at launch and on every accent
  # change, so a running aoide follows the shell's accent live; aoide watches the
  # link's target. not in programs.aoide.themes, which would write a fixed file
  xdg.configFile."aoide/themes/cendre.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.xdg.stateHome}/pyrrha/aoide-theme.toml";
}
