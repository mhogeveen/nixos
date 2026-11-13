{ pkgs, ... }:
let
  # mango has wlr-output-power-management: this powers the screen down like
  # dpms, without removing the output the way `mmsg dispatch disable_monitor` does
  wlopm = "${pkgs.wlopm}/bin/wlopm";
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
