let
  adminUser = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzHMObNor0UyUOtyPjNQNHLNKf2RnAlQ1vJ50+tIt3v admin@dhs";
  dhsServer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICIQ0kQfmyndwCBlktgBvsAk3WBagbu0kKFGm+5ofXXv root@dhs";
in
{
  "stalwart-admin.age".publicKeys = [
    adminUser
    dhsServer
  ];
}
