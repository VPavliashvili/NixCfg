let
  keys = import ../keys.nix;

  hostkeys = builtins.attrValues keys.hosts;
in {
  "liberty-password.age".publicKeys = hostkeys;
  "liberty-cert-pwd.age".publicKeys = hostkeys;
  "liberty-cert-pfx.age".publicKeys = hostkeys;
  "duckdns-token.age".publicKeys = hostkeys;
}
