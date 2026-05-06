let
  dorthonion_host_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMg420Po/NOUvn4zWJBCZ2qsy7Kkai+lRlqnBQ8n9I++ root@dorthonion";
  rivendell_host_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICMkIcZXUOMZ5P7QyXV0F+goMum/ALMX0GtwXX8dVntB root@rivendell";
  parthgalen_host_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP8+oqruLUHAXG/AYTpIN6XkcwAw6YQIRGLixdIZ30/w root@parthGalen";

  hostkeys = [
    dorthonion_host_key
    rivendell_host_key
    parthgalen_host_key
  ];
in {
  "liberty-password.age".publicKeys = hostkeys;
  "liberty-cert-pwd.age".publicKeys = hostkeys;
  "liberty-cert-pfx.age".publicKeys = hostkeys;
  "duckdns-token.age".publicKeys = hostkeys;
}
