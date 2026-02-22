/*
  modules/nixos/default.nix

  part of der-home-server
  created 2026-02-23
*/

{
  # list module files here
  common = import ./common;
  dashboard = import ./dashboard;
  services = import ./services;
}
