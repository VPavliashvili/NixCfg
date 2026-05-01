{
  config,
  pkgs,
  lib,
  ...
}: {
  services.glances = {
    enable = true;
    openFirewall = true;
  };

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    allowedHosts = "192.168.1.240:8082";

    settings = {
      title = "Rivendell";
      headerStyle = "clean";
      statusStyle = "dot";
      layout = [
        {
          Glances = {
            header = false;
            style = "row";
            columns = 4;
          };
        }
        {Media = {style = "column";};}
        {Downloads = {style = "column";};}
      ];
    };
    services = [
      {
        Media = [
          {
            Jellyfin = {
              href = "http://192.168.1.240:8096";
              icon = "jellyfin.png";
            };
          }
          {
            Jellyseerr = {
              href = "http://192.168.1.240:5055";
              icon = "jellyseerr.png";
            };
          }
        ];
      }
      {
        Downloads = [
          {
            Deluge = {
              href = "http://192.168.1.240:8112";
              icon = "deluge.png";
            };
          }
          {
            Radarr = {
              href = "http://192.168.1.240:7878";
              icon = "radarr.png";
            };
          }
          {
            Sonarr = {
              href = "http://192.168.1.240:8989";
              icon = "sonarr.png";
            };
          }
          {
            Prowlarr = {
              href = "http://192.168.1.240:9696";
              icon = "prowlarr.png";
            };
          }
          {
            Bazarr = {
              href = "http://192.168.1.240:6767";
              icon = "bazarr.png";
            };
          }
        ];
      }
      {
        Glances = let
          port = "61208";
        in [
          {
            Info = {
              widget = {
                type = "glances";
                url = "http://localhost:${port}";
                metric = "info";
                chart = false;
                version = 4;
              };
            };
          }
          {
            "CPU Temp" = {
              widget = {
                type = "glances";
                url = "http://localhost:${port}";
                metric = "sensor:Package id 0";
                chart = false;
                version = 4;
              };
            };
          }
          {
            Processes = {
              widget = {
                type = "glances";
                url = "http://localhost:${port}";
                metric = "process";
                chart = false;
                version = 4;
              };
            };
          }
          {
            Network = {
              widget = {
                type = "glances";
                url = "http://localhost:${port}";
                metric = "network:enp3s0";
                chart = false;
                version = 4;
              };
            };
          }
        ];
      }
    ];
  };
}
