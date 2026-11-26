# what every host shares; a host's own folder adds its hardware, its name and
# whatever is tuned to that machine
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  strata = inputs.strata.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
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
    powerOnBoot = true;
    # many headsets only report their battery level to bluez with this on
    settings.General.Experimental = true;
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
  services.gnome.gnome-keyring.enable = true;
  # trash, network shares and drive discovery in strata's sidebar (udisks2 is already on)
  services.gvfs.enable = true;

  # strata (home/strata.nix): its open/save dialog portal, gtk as fallback. the key goes
  # under mango because mango-portals.conf (from the mango module) overrides `common`
  xdg.portal.extraPortals = [ strata.fileChooserPortal ];
  xdg.portal.config.mango."org.freedesktop.impl.portal.FileChooser" = [
    "strata"
    "gtk"
  ];
  # org.freedesktop.FileManager1, so "show in folder" opens strata
  services.dbus.packages = [ strata.fileManagerService ];

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
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        # 1Password – Password Manager
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
        };
        # "Dark" theme (nicedarktheme); made the active theme in home/firefox/user-overrides.js
        "{7cbdf3df-936d-4b13-811f-320bf981f801}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/nicedarktheme/latest.xpi";
        };
      };
    };
  };
  programs.mango.enable = true;

  # system modules, not home.packages: they install the setgid wrapper and
  # polkit policy needed for system-auth unlock, `op` CLI and browser integration
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ config.user.name ];
  };

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
  # SMART checks on the disks; warnings land in the journal
  services.smartd.enable = true;

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
    # system-side so the binary matches the portal and D-Bus files above
    strata
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

  # enabled by default on graphical desktops; pulls in ~1.2 GiB of TTS voices
  services.speechd.enable = false;
  # flakes only: <nixpkgs> and nix-shell -p resolve through the flake registry
  nix.channel.enable = false;
}
