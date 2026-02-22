let
  adminUser = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKs6Pw0mwJ5U/2HOkAID+ha9VFNp3Pm1eVF1HkFuYRsW admin@dhs";
  dhsServer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICIQ0kQfmyndwCBlktgBvsAk3WBagbu0kKFGm+5ofXXv root@dhs";
in
{
  "secrets/stalwart-admin.age".publicKeys = [
    adminUser
    dhsServer
  ];
}
