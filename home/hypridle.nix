{ osConfig, pkgs, ... }:
let
  # mango has wlr-output-power-management: this powers the screen down like
  # dpms, without removing the output the way `mmsg dispatch disable_monitor` does
  wlopm = "${pkgs.wlopm}/bin/wlopm";

  # the i2c bus the monitor answers on, per host (modules/user.nix), and how far
  # to dim before the lock
  monitorBus = toString osConfig.user.monitor.i2cBus;
  dimLevel = "10";

  # dims the monitor over DDC/CI before the lock and puts back the level it had
  # (not a fixed 100). ddcutil takes ~0.4 s per call, so a restore could start
  # while a dim is still writing; flock keeps them in order. the amane shell's
  # popup only follows changes the shell makes, so this doesn't show it
  dimMonitor = pkgs.writeShellScript "dim-monitor" ''
    ddcutil=${pkgs.ddcutil}/bin/ddcutil
    saved="$XDG_RUNTIME_DIR/hypridle-brightness"

    exec 9>"$saved.lock"
    ${pkgs.util-linux}/bin/flock 9

    case "$1" in
      dim)
        # "VCP 10 C 50 100": the fourth field is the current level
        level=$($ddcutil --bus ${monitorBus} getvcp 10 --brief | cut -d' ' -f4)

        # already this dim (or unreadable): nothing to put back later
        if [ -n "$level" ] && [ "$level" -gt ${dimLevel} ]; then
          echo "$level" > "$saved"
          $ddcutil --bus ${monitorBus} setvcp 10 ${dimLevel} --noverify
        fi
        ;;
      restore)
        # only after a dim, so a second resume doesn't undo a change made since
        if [ -f "$saved" ]; then
          $ddcutil --bus ${monitorBus} setvcp 10 "$(cat "$saved")" --noverify
          rm -f "$saved"
        fi
        ;;
    esac
  '';
in
{
  services.hypridle = {
    enable = true;
    # the NixOS session wrapper brings up graphical-session.target before mango
    # has exported WAYLAND_DISPLAY, so hypridle would be skipped; mango-session
    # starts once the compositor is up
    systemdTarget = "mango-session.target";

    settings = {
      general = {
        # the amane shell locks by itself on logind's Lock and PrepareForSleep
        # signals, so no lock_cmd here
        #
        # mango has no lock-notify protocol, so hypridle can't wait for the lock
        # screen (inhibit_sleep = 3); a second after locking does, the same
        # delay the shell's session menu uses before suspending
        before_sleep_cmd = "loginctl lock-session && sleep 1";
        after_sleep_cmd = "${wlopm} --on '*'";
        inhibit_sleep = 1;
      };

      listener = [
        # dim half a minute before the lock, as a warning; hypridle runs every
        # fired listener's on-resume on activity, so this also restores after
        # the screen was off
        {
          timeout = 270;
          on-timeout = "${dimMonitor} dim";
          on-resume = "${dimMonitor} restore";
        }
        # lock after 5 minutes
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        # screen off half a minute later
        {
          timeout = 330;
          on-timeout = "${wlopm} --off '*'";
          on-resume = "${wlopm} --on '*'";
        }
        # suspend after 30 minutes
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
