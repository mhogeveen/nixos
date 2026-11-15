{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev"; # EFI only, no MBR install
    configurationLimit = 10;
    theme = pkgs.callPackage ./grub-theme { };
    gfxmodeEfi = "3840x2160,auto"; # native 4K; non-native modes get upscaled and blurry
    gfxpayloadEfi = "keep";
    splashImage = null; # theme draws a plain black background
    backgroundColor = "#000000";
    # Runs at the start of every entry, before GRUB loads kernel + initrd (takes a few seconds):
    # wipe GRUB's built-in "Booting `NixOS'" line and show our own message instead
    extraPerEntryConfig = ''
      clear
      echo "Loading kernel..."
    '';
    # useOSProber = true; # enable only if dual-booting
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # HP's BIOS-settings driver: its WMI queries fail on this box and freeze the
  # whole machine for ~17 s during boot. only /sys/class/firmware-attributes
  # (BIOS settings from Linux) is lost
  boot.blacklistedKernelModules = [ "hp_bioscfg" ];

  networking.hostName = "prometheus";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  # modules/user.nix
  user.name = "maarten";
  user.flakeDir = "${config.users.users.${config.user.name}.home}/.nixos";
  user.location = {
    latitude = 52.2;
    longitude = 5.2;
  };

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
  hardware.i2c.enable = true;

  services.displayManager.ly.enable = true;
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main.capslock = "overload(control, esc)";
    };
  };
  services.tailscale.enable = true;

  users.users.${config.user.name} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  programs.firefox = {
    enable = true;
    # shown under about:policies
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      FirefoxHome = {
        SponsoredTopSites = false;
        SponsoredPocket = false;
        SponsoredStories = false;
      };
      ExtensionSettings."uBlock0@raymondhill.net" = {
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      };
    };
  };
  programs.mango.enable = true;

  # dconf's D-Bus service; home-manager writes the GTK dark mode and cursor
  # settings (gtk.nix, cursor.nix) into it. niri used to enable this implicitly
  programs.dconf.enable = true;
  programs.zsh = {
    enable = true;
    # home-manager's zsh runs compinit already; running it here too slows startup
    enableGlobalCompInit = false;
  };

  # realtime scheduling for PipeWire (enabled by the graphical desktop defaults)
  security.rtkit.enable = true;

  services.fwupd.enable = true;
  # SMART checks on the one SSD; warnings land in the journal
  services.smartd.enable = true;

  # 6.7 GiB of RAM: let zram (zstd) grow to the size of RAM and prefer it over
  # dropping file cache; the disk swap stays as the lower-priority fallback
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    # zram has no seek cost, so no swap readahead
    "vm.page-cluster" = 0;
  };
  boot.tmp.cleanOnBoot = true;

  # Provides the generic linux dynamic loader so prebuilt binaries (e.g. Mason's
  # language servers in Neovim) can run.
  programs.nix-ld.enable = true;

  programs.nh = {
    enable = true;
    flake = config.user.flakeDir;
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
    # amane's own wrapper bundles cargo + rustc (~1.6 GiB) so its CLI can build the config;
    # re-wrap it without them so it uses the rustup toolchain from home/packages.nix instead
    (inputs.amane.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (_: {
      postFixup =
        let
          libraries = with pkgs; [
            fontconfig
            freetype
            expat
            wayland
            libxkbcommon
            vulkan-loader
            libpulseaudio
            linux-pam
          ];
        in
        ''
          wrapProgram $out/bin/amane \
            --prefix PATH : ${
              lib.makeBinPath [
                pkgs.pkg-config
                pkgs.stdenv.cc
              ]
            } \
            --prefix PKG_CONFIG_PATH : ${lib.makeSearchPathOutput "dev" "lib/pkgconfig" libraries} \
            --prefix LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.linux-pam ]} \
            --prefix LD_LIBRARY_PATH : ${
              lib.makeLibraryPath [
                pkgs.vulkan-loader
                pkgs.wayland
              ]
            }
        '';
    }))
    ddcutil
    pciutils
    usbutils
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.blex-mono
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.optimise.automatic = true;
  # 4 slow cores: builds run at idle priority, two at a time, so the desktop
  # stays usable during a rebuild (amane's Rust build is the heavy one)
  nix.settings.max-jobs = 2;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

  # enabled by default on graphical desktops; pulls in ~1.2 GiB of TTS voices
  services.speechd.enable = false;
  # flakes only: <nixpkgs> and nix-shell -p resolve through the flake registry
  nix.channel.enable = false;

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
