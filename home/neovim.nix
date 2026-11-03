{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    # Only available on Neovim's PATH, not globally.
    extraPackages = with pkgs; [
      fzf
      luarocks
      ripgrep
      fd
      gcc
      tree-sitter
      nodejs
      unzip
      go
    ];
  };

  # home-manager generates an init.lua (provider toggles only) that would clash
  # with the linked config directory below; the dotfiles' init.lua is used instead.
  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

  # Out-of-store symlink so edits apply immediately and lazy.nvim can write lazy-lock.json.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/config/neovim/.config/nvim";
}
