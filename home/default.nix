{ ... }:
{
  imports = [
    ./cursor.nix
    ./foot.nix
    ./git.nix
    ./gtk.nix
    ./hypridle.nix
    ./mango.nix
    ./neovim.nix
    ./packages.nix
    ./satty.nix
    ./wlsunset.nix
    ./zsh.nix
  ];

  # home.username and home.homeDirectory come from users.users (the home-manager
  # NixOS module sets them), so the name lives only in modules/user.nix

  home.stateVersion = "26.05";
}
