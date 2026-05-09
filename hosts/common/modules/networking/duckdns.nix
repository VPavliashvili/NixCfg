{
  config,
  pkgs,
  mainUser,
  allowedHosts,
  lib,
  ...
}: {
  config = {
    age.secrets.duckdns = {
      file = ../../../../secrets/duckdns-token.age;
      owner = "caddy";
    };
  };
}
