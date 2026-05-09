{
  config,
  pkgs,
  mainUser,
  allowedHosts,
  lib,
  ...
}: {
  config = {
    services.calibre-web = {
      enable = true;
      listen = {
        ip = "0.0.0.0";
        port = 8083;
      };
      options = {
        calibreLibrary = "/srv/calibre-library";
        enableBookUploading = true;
        enableBookConversion = true;
      };
    };

    systemd.services.calibre-import = {
      description = "sync new books from storage into calibre library";
      serviceConfig = {
        Type = "oneshot";
        User = "calibre-web";
        ExecStart = "${pkgs.calibre}/bin/calibredb add /storage/media/books/ --recurse --with-library /srv/calibre-library";
      };
    };

    systemd.timers.calibre-import = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*:0/1";
        Persistent = true;
      };
    };

    networking.firewall.allowedTCPPorts = [8083];
  };
}
