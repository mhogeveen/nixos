{ inputs, lib, ... }:
let
  # the keybinds, as groups rendered into extraConfig: "# heading" (plus any
  # comment lines) and then the group's bind lines. the amane shell's keybind
  # sheet (SUPER+/) lists every bind under the first line of the comment block
  # above it, cut at a , : ; or (, so keep each heading short. settings would
  # drop the comments and sort the keys, hence not there
  keybinds = [
    {
      heading = "shell panels";
      comment = [ "SUPER+m opens the session menu, which asks twice before logging out" ];
      lines = [
        "bind=SUPER,space,spawn_shell,amane ipc call panel toggle launcher"
        "bind=SUPER,c,spawn_shell,amane ipc call panel toggle clipboard"
        "bind=SUPER,s,spawn_shell,amane ipc call panel toggle system"
        "bind=SUPER,n,spawn_shell,amane ipc call panel toggle layout"
        "bind=SUPER,p,spawn_shell,amane ipc call record menu"
        "bind=SUPER,w,spawn_shell,amane ipc call panel toggle wallpaper"
        "bind=SUPER,d,spawn_shell,amane ipc call panel toggle calendar"
        "bind=SUPER,u,spawn_shell,amane ipc call panel toggle notifications"
        "bind=SUPER+SHIFT,a,spawn_shell,amane ipc call panel toggle audio"
        "bind=SUPER+SHIFT,n,spawn_shell,amane ipc call panel toggle network"
        "bind=SUPER+SHIFT,b,spawn_shell,amane ipc call panel toggle bluetooth"
        "bind=SUPER,m,spawn_shell,amane ipc call panel toggle session"
        "bind=SUPER,slash,spawn_shell,amane ipc call panel toggle keybinds"
      ];
    }
    {
      heading = "apps";
      lines = [
        "bind=SUPER,b,spawn,firefox"
        "bind=SUPER,t,spawn,footclient"
      ];
    }
    {
      heading = "mango";
      lines = [ "bind=SUPER,r,reload_config" ];
    }
    {
      heading = "focus window";
      lines = [
        "bind=SUPER,h,focusdir,left"
        "bind=SUPER,j,focusdir,down"
        "bind=SUPER,k,focusdir,up"
        "bind=SUPER,l,focusdir,right"
        "bind=SUPER,Tab,togglejump,"
      ];
    }
    {
      heading = "move window";
      lines = [
        "bind=SUPER+SHIFT,h,move_client,left"
        "bind=SUPER+SHIFT,j,move_client,down"
        "bind=SUPER+SHIFT,k,move_client,up"
        "bind=SUPER+SHIFT,l,move_client,right"
      ];
    }
    {
      heading = "resize window";
      lines = [
        "bind=CTRL+ALT,h,resizewin,-50,+0"
        "bind=CTRL+ALT,j,resizewin,+0,+50"
        "bind=CTRL+ALT,k,resizewin,+0,-50"
        "bind=CTRL+ALT,l,resizewin,+50,+0"
      ];
    }
    {
      heading = "window state";
      lines = [
        "bind=SUPER,q,killclient,"
        "bind=ALT,backslash,togglefloating,"
        "bind=SUPER,f,togglemaximizescreen,"
        "bind=ALT,f,togglefullscreen,"
        "bind=ALT+SHIFT,f,togglefakefullscreen,"
        "bind=SUPER,o,toggleoverlay,"
        "bind=SUPER,g,toggleglobal,"
      ];
    }
    {
      heading = "minimize and scratchpad";
      lines = [
        "bind=SUPER,i,minimized,"
        "bind=SUPER+SHIFT,I,restore_minimized"
        "bind=ALT,z,toggle_scratchpad"
      ];
    }
    {
      heading = "switch workspace";
      lines = [
        "bind=SUPER,Left,viewtoleft,0"
        "bind=SUPER,Right,viewtoright,0"
        "bind=CTRL,Left,viewtoleft_have_client,0"
        "bind=CTRL,Right,viewtoright_have_client,0"
      ]
      ++ map (i: "bind=SUPER,${toString i},view,${toString i},0") workspaces;
    }
    {
      heading = "move window to workspace";
      comment = [
        "tag: move client to the tag and focus it"
        "tagsilent: move client to the tag and not focus it"
        "bind=Alt,1,tagsilent,1"
      ];
      lines = [
        "bind=CTRL+SUPER,Left,tagtoleft,0"
        "bind=CTRL+SUPER,Right,tagtoright,0"
      ]
      ++ map (i: "bind=SUPER+SHIFT,${toString i},tag,${toString i},0") workspaces;
    }
    {
      heading = "scroller layout";
      lines = [
        "bind=ALT,e,set_proportion,1.0"
        "bind=SUPER,v,switch_proportion_preset,"
        "bind=alt+super+ctrl,Left,scroller_stack,left"
        "bind=alt+super+ctrl,Right,scroller_stack,right"
        "bind=alt+super+ctrl,Up,scroller_stack,up"
        "bind=alt+super+ctrl,Down,scroller_stack,down"
      ];
    }
    {
      heading = "mouse";
      lines = [
        "mousebind=SUPER,btn_left,moveresize,curmove"
        "mousebind=SUPER,btn_right,moveresize,curresize"
      ];
    }
    {
      heading = "volume, through wpctl, capped at 100%; the amane shell shows a popup for any change";
      lines = [
        "bindl=SUPER,equal,spawn,wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        "bindl=SUPER,minus,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "bindl=SUPER,0,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "bindl=SUPER+SHIFT,0,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
    }
    {
      heading = "brightness, through the shell (DDC/CI for this monitor), 5% a press, with a popup";
      lines = [
        "bindl=SUPER+SHIFT,equal,spawn,amane ipc call brightness up"
        "bindl=SUPER+SHIFT,minus,spawn,amane ipc call brightness down"
      ];
    }
    {
      heading = "playback, through the shell's media ipc (amane's MPRIS service)";
      lines = [
        "bindl=SUPER,backslash,spawn,amane ipc call media play-pause"
        "bindl=SUPER,bracketright,spawn,amane ipc call media next"
        "bindl=SUPER,bracketleft,spawn,amane ipc call media previous"
      ];
    }
    {
      heading = "the same for media keys, should the keyboard ever send them (like a remapped Fn layer)";
      lines = [
        "bindl=NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        "bindl=NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "bindl=NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "bindl=NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        "bindl=NONE,XF86AudioPlay,spawn,amane ipc call media play-pause"
        "bindl=NONE,XF86AudioNext,spawn,amane ipc call media next"
        "bindl=NONE,XF86AudioPrev,spawn,amane ipc call media previous"
        "bindl=NONE,XF86MonBrightnessUp,spawn,amane ipc call brightness up"
        "bindl=NONE,XF86MonBrightnessDown,spawn,amane ipc call brightness down"
      ];
    }
  ];

  workspaces = lib.range 1 9;

  renderGroup =
    group:
    lib.concatLines (
      [
        ""
        "# ${group.heading}"
      ]
      ++ map (line: "# ${line}") (group.comment or [ ])
      ++ group.lines
    );
in
{
  imports = [ inputs.mangowm.hmModules.mango ];

  wayland.windowManager.mango = {
    enable = true;

    # restart rather than start, for fresh session units on every login: a quick
    # re-login reuses the user manager, and units from the last session (foot
    # server, hypridle, wlsunset) are failed or still talking to the old compositor
    systemd.extraCommands = [
      "systemctl --user reset-failed"
      "systemctl --user restart mango-session.target"
    ];

    # a non-empty autostart is what makes the module add the exec_once that
    # imports the session environment and runs the commands above
    autostart_sh = "exec amane run";

    # more options: https://github.com/DreamMaoMao/mango/wiki/
    # floats are strings, toKeyValue would print 1.0 as 1.000000
    settings = {
      xwayland_ignore_scale = 1;
      monitor_rule = "name:DP-1,width:3840,height:2160,refresh:60,x:0,y:0,primary:1,scale:1.5";

      animations = 0;

      # scroller layout
      scroller_structs = 4;
      scroller_default_proportion = "1.0";
      scroller_proportion_preset = "0.5,0.75,1.0";

      # cursor, the same size as home.pointerCursor (cursor.nix)
      cursor_theme = "Adwaita";
      cursor_size = 20;

      # keyboard
      repeat_rate = 30;
      repeat_delay = 225;
      xkb_rules_layout = "us";

      # a fullscreen window (video, a game) on a shown workspace keeps
      # hypridle from dimming, locking or suspending, like the shell's Idle
      # switch does by hand; off by default
      idle_inhibit_when_fullscreen = 1;

      # appearance
      gap_inner_horizontal = 4;
      gap_inner_vertical = 4;
      gap_outer_horizontal = 4;
      gap_outer_vertical = 4;
      border_px = 1;
      root_color = "0x0f0c0aff";
      border_color = "0x4e4641ff";
      drop_color = "0x8FBA7C55";
      focus_color = "0x73665bff";

      # tile,scroller,grid,deck,monocle,center_tile,vertical_tile,vertical_scroller
      tag_rule = map (i: "id:${toString i},layout_name:scroller") workspaces;

      # satty (screenshot annotation, the shell's "Region (annotate)") floats,
      # centered and sized to the capture by satty itself, instead of tiling
      window_rule = [ "is_floating:1,app_id:com.gabm.satty" ];
    };

    extraConfig = lib.concatMapStrings renderGroup keybinds;
  };
}
