{ ... }:
{
  imports = [
    ./btop.nix
    ./cursor.nix
    ./delta.nix
    ./eza.nix
    ./firefox.nix
    ./foot.nix
    ./fzf.nix
    ./git.nix
    ./gtk.nix
    ./hypridle.nix
    ./lazygit.nix
    ./mango.nix
    ./neovim.nix
    ./packages.nix
    ./satty.nix
    ./strata.nix
    ./wlsunset.nix
    ./yazi.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  # home.username and home.homeDirectory come from users.users (the home-manager
  # NixOS module sets them), so the name lives only in modules/user.nix

  home.stateVersion = "26.05";
}
