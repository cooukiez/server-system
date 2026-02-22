/*
  secrets/secrets.nix

  part of der-home-server
  created 2026-02-22
*/

let
  adminUser = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzHMObNor0UyUOtyPjNQNHLNKf2RnAlQ1vJ50+tIt3v admin@dhs";
  dhsServer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICIQ0kQfmyndwCBlktgBvsAk3WBagbu0kKFGm+5ofXXv root@dhs";
in
{
  # stalwart keys
  "stalwart-admin.age".publicKeys = [
    adminUser
    dhsServer
  ];

  "stalwart-ludwig.age".publicKeys = [
    adminUser
    dhsServer
  ];
}
