{ inputs, ... }:
let
  # fixed in profiles.ini below, so a fresh install uses the same dir
  profile = "default";
  overrides = ./firefox/user-overrides.js;
in
{
  xdg.configFile."mozilla/firefox/profiles.ini".text = ''
    [General]
    StartWithLastProfile=1
    Version=2

    [Profile0]
    Name=default
    IsRelative=1
    Path=${profile}
    Default=1
  '';

  xdg.configFile."mozilla/firefox/${profile}/user-overrides.js".source = overrides;
  # arkenfox's user.js with our overrides appended, like arkenfox's updater.sh builds it
  xdg.configFile."mozilla/firefox/${profile}/user.js".text =
    builtins.readFile "${inputs.arkenfox}/user.js" + builtins.readFile overrides;
}
