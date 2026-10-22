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
          "github.com/mholt/caddy-ratelimit@v0.1.0"
        ];
        hash = "sha256-JZ9f4s5ypWeW4seeEroFAo/W9PbZuk58nTwTd8/nElo=";
      };

      globalConfig = ''
        order rate_limit before basic_auth
      '';

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

      virtualHosts."immich.esgalmar.net:10443" = {
        extraConfig = ''
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          }

          rate_limit {
            # login endpoints: strict
            zone immich_auth {
              match {
                path /api/auth/* /api/oauth/*
              }
              key {remote_host}
              events 20
              window 1m
            }
            # everything else: generous, timeline scrolling loads hundreds of thumbnails
            zone immich_all {
              key {remote_host}
              events 3000
              window 1m
            }
          }

          reverse_proxy localhost:2283
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

    networking.firewall.allowedTCPPorts = [80 443 10443];
  };
}
