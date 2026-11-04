{ ... }:
{
  programs.qutebrowser = {
    enable = true;

    settings = {
      auto_save = {
	session = true;
      };
      completion = {
	delay = 300;
	height = "25%";
	min_chars = 2;
	shrink = true;
      };
      content = {
	blocking = {
	  enabled = true;
	  method = "adblock";
	};
	prefers_reduced_motion = true;
      };
      tabs.position = "left";
      colors = {
	webpage = {
	  darkmode.enabled = true;
	  preferred_color_scheme = "dark";
	};
      };
    };

    extraConfig = ''
      config.source('noctalia/colors.py')
      c.tabs.padding = {"bottom": 5, "left": 5, "right": 5, "top": 5}
    '';
  };
}
