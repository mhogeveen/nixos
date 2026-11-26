{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "prometheus";

  # modules/user.nix
  user.monitor = {
    output = "DP-1";
    # amane's docs/machine.md
    i2cBus = 5;
  };

  # HP's BIOS-settings driver: its WMI queries fail on this box (ACPI errors
  # at every boot); only /sys/class/firmware-attributes is lost
  boot.blacklistedKernelModules = [ "hp_bioscfg" ];

  # Secure Boot is off on this machine, so dbx updates are pointless (and fail: NVRAM too full)
  services.fwupd.daemonSettings.DisabledPlugins = [ "uefi_dbx" ];

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

  # 4 slow cores: builds run at idle priority, two at a time, so the desktop
  # stays usable during a rebuild (amane's Rust build is the heavy one)
  nix.settings.max-jobs = 2;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
