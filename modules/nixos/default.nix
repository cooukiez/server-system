/*
  modules/nixos/default.nix

  part of der-home-server
  created 2026-02-21
*/

{
  # list module files here
  common = import ./common;
  services = import ./services;
}
