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
    device = "/dev/disk/by-uuid/2fd28719-a6f7-428a-8eb8-3bf2d81bb1f5";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/2fd28719-a6f7-428a-8eb8-3bf2d81bb1f5";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2fd28719-a6f7-428a-8eb8-3bf2d81bb1f5";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/2fd28719-a6f7-428a-8eb8-3bf2d81bb1f5";
    fsType = "btrfs";
    options = [ "subvol=var" ];
  };

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/2fd28719-a6f7-428a-8eb8-3bf2d81bb1f5";
    fsType = "btrfs";
    options = [ "subvol=data" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/bf82d1d9-f61b-48b7-b1ab-605240561086"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
