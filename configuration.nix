{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "prometheus";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };


  services.displayManager.ly.enable = true;
  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];

      settings = {
        main = {
          capslock = "overload(control, esc)";
        };
      };
    };
  };

  users.users.maarten = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  programs.firefox.enable = true;
  programs.niri.enable = true;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    ghostty
    alacritty
    fuzzel
    noctalia

    # shell programs
    eza
    lazygit
    zoxide

    # neovim requirements
    neovim
    fzf
    luarocks
    ripgrep
    fd
    gcc
    tree-sitter
    nodejs
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.blex-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
