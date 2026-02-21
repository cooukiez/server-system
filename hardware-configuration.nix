/*
  hardware-configuration.nix

  part of der-home-server
  created 2026-02-21
*/

# generated config by nixos
# do not modify this file

{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "sdhci_pci"
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/20913f95-2766-4216-a920-8e080cd1fd17";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B72C-E22D";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/20913f95-2766-4216-a920-8e080cd1fd17";
    fsType = "btrfs";
    options = [ "subvol=data" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/20913f95-2766-4216-a920-8e080cd1fd17";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/20913f95-2766-4216-a920-8e080cd1fd17";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/20913f95-2766-4216-a920-8e080cd1fd17";
    fsType = "btrfs";
    options = [ "subvol=var" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
