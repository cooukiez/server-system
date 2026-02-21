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
    device = "/dev/disk/by-uuid/261fcaf4-c663-45e2-90f8-989fd0273cbc";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/261fcaf4-c663-45e2-90f8-989fd0273cbc";
    fsType = "btrfs";
    options = [ "subvol=data" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/261fcaf4-c663-45e2-90f8-989fd0273cbc";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/261fcaf4-c663-45e2-90f8-989fd0273cbc";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/261fcaf4-c663-45e2-90f8-989fd0273cbc";
    fsType = "btrfs";
    options = [ "subvol=var" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
