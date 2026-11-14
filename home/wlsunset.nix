{ osConfig, ... }:
{
  # night light: warmer colors from sunset to sunrise (mango has
  # wlr-gamma-control); the amane shell's system panel only starts and stops
  # this unit, so switching it off lasts until the next login
  services.wlsunset = {
    enable = true;
    # the NixOS session wrapper brings up graphical-session.target before mango
    # has exported WAYLAND_DISPLAY (see hypridle.nix); mango-session starts once
    # the compositor is up
    systemdTarget = "mango-session.target";

    # the host's location (modules/user.nix); sunset and sunrise follow from it
    inherit (osConfig.user.location) latitude longitude;

    temperature.night = 3400;
  };
}
