{ pkgs, inputs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "prometheus";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "nl_NL.UTF-8";
      LC_MEASUREMENT = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
      LC_PAPER = "nl_NL.UTF-8";
      LC_TELEPHONE = "nl_NL.UTF-8";
      LC_TIME = "nl_NL.UTF-8";
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

  services.displayManager.ly.enable = true;
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main.capslock = "overload(control, esc)";
    };
  };

  users.users.maarten = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  programs.firefox.enable = true;
  programs.niri.enable = true;
  programs.mango.enable = true;
  programs.zsh.enable = true;

  # Provides the generic linux dynamic loader so prebuilt binaries (e.g. Mason's
  # language servers in Neovim) can run.
  programs.nix-ld.enable = true;

  programs.nh = {
    enable = true;
    flake = "/home/maarten/.nixos";
    clean = {
      enable = true;
      extraArgs = "--keep-since 14d --keep 5";
    };
  };

  # Lets zsh pick up completions from home-manager (useUserPackages) packages.
  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
    wget
    wl-clipboard
    noctalia
    inputs.amane.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.blex-mono
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.optimise.automatic = true;

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
