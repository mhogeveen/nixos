# per-user constants shared by the NixOS and home-manager config, set per host;
# home-manager modules read them as osConfig.user.*
{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.user = {
    name = mkOption {
      type = types.passwdEntry types.str;
      description = "The login name of the user this host is set up for.";
      example = "maarten";
    };

    flakeDir = mkOption {
      type = types.str;
      description = "Where this flake is checked out (for nh and out-of-store dotfile links).";
      example = "/home/maarten/.nixos";
    };

    location = {
      latitude = mkOption {
        type = types.numbers.between (-90) 90;
        description = "Where this host usually is, in degrees north (for sunset times).";
        example = 52.2;
      };

      longitude = mkOption {
        type = types.numbers.between (-180) 180;
        description = "Where this host usually is, in degrees east (for sunset times).";
        example = 5.2;
      };
    };

    # the monitor is the same on every host; where it shows up depends on the
    # port it is plugged into
    monitor = {
      output = mkOption {
        type = types.str;
        description = "The compositor's name for the output the monitor is on (`nix run nixpkgs#wlr-randr`).";
        example = "DP-1";
      };

      i2cBus = mkOption {
        type = types.ints.unsigned;
        description = "The i2c bus the monitor answers DDC/CI on (`ddcutil detect`), for dimming before the lock.";
        example = 5;
      };
    };
  };
}
