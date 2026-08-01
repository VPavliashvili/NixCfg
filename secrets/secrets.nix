let
  keys = import ../keys.nix;

  hostkeys = builtins.attrValues keys.hosts;
in {
  "liberty-password.age".publicKeys = hostkeys;
  "liberty-cert-pwd.age".publicKeys = hostkeys;
  "liberty-cert-pfx.age".publicKeys = hostkeys;
  "duckdns-token.age".publicKeys = hostkeys;
  "cloudflare-token.age".publicKeys = hostkeys;
  "wg-dorthonion-private.age".publicKeys = [keys.hosts.dorthonion];
  "wg-parthgalen-private.age".publicKeys = [keys.hosts.parthgalen];
  "wg-numenor-private.age".publicKeys = [keys.hosts.numenor];
}
