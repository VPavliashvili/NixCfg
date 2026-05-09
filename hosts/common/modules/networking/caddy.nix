{
  config,
  pkgs,
  mainUser,
  allowedHosts,
  lib,
  ...
}: {
  config = {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/duckdns@v0.5.0"];
        hash = "sha256-MYE+VBEZ93QmpyT4RcH4hY+G7y1IwBWwcZ1J/4XrZK4=";
      };
      virtualHosts."esgalmar.duckdns.org" = {
        extraConfig = ''
          tls {
            dns duckdns {env.DUCKDNS_TOKEN}
          }
          reverse_proxy localhost:8096
        '';
      };
    };

    systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.duckdns.path;

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
