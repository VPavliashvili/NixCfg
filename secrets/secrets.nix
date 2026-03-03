let
  dorthonion_host_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMg420Po/NOUvn4zWJBCZ2qsy7Kkai+lRlqnBQ8n9I++ root@dorthonion";

  hostkeys = [dorthonion_host_key];
in {
  "liberty-password.age".publicKeys = hostkeys;
  "liberty-cert-pwd.age".publicKeys = hostkeys;
  "liberty-cert-pfx.age".publicKeys = hostkeys;
}
