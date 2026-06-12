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
        plugins = [
          "github.com/caddy-dns/cloudflare@v0.2.4"
        ];
        hash = "sha256-8yZDrejNKsaUnUaTUFYbarWNmxafqp2z2rWo+XRsxV8=";
      };
      virtualHosts."jellyfin.esgalmar.net" = {
        extraConfig = ''
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          }
          reverse_proxy localhost:8096
        '';
      };
    };

    age.secrets.cloudflare = {
      file = ../../../../secrets/cloudflare-token.age;
      owner = "caddy";
    };

    systemd.services.caddy.serviceConfig.EnvironmentFile = [
      config.age.secrets.cloudflare.path
    ];

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
