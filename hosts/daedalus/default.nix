{ lib, ... }:
{
  # from `nixos-generate-config --show-hardware-config` on this machine
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "daedalus";

  # this firmware puts its own "UEFI OS" entry (the fallback path,
  # EFI/BOOT/BOOTX64.EFI) ahead of NixOS-boot, so GRUB goes to that path
  # instead of into a boot entry of its own
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  # modules/user.nix. copied from prometheus, so check both on this machine:
  # `nix run nixpkgs#wlr-randr` for the output's name, `ddcutil detect` for the bus
  user.monitor = {
    output = "DP-1";
    i2cBus = 5;
  };

  # the release this machine was first installed with (system.stateVersion in
  # the /etc/nixos/configuration.nix the installer wrote), not the one it runs.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
