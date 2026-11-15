{ inputs, ... }:
{
  programs.btop = {
    enable = true;

    # cendre (hard), https://github.com/Aejkatappaja/cendre (extras/btop/cendre.toml)
    themes.cendre = "${inputs.cendre}/extras/btop/cendre.toml";

    settings = {
      color_theme = "cendre";
      vim_keys = true;
      update_ms = 2000;
    };
  };
}
