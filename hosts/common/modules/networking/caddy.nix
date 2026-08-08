{
  config,
  pkgs,
  mainUser,
  allowedHosts,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.networking;
in {
  options.modules.networking = {
    enableCaddy = mkEnableOption "enable caddy for this host(usage only expected by rivendell)";
  };

  config = mkIf cfg.enableCaddy {
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

      # localhost:9091 is authelia
      virtualHosts."auth.esgalmar.net" = {
        extraConfig = ''
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          }
          reverse_proxy localhost:9091
        '';
      };

      virtualHosts."seerr.esgalmar.net" = {
        extraConfig = ''
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          }
          forward_auth localhost:9091 {
            uri /api/authz/forward-auth
            copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
          }
          reverse_proxy localhost:5055
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
