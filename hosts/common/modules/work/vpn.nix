{lib, config, pkgs, mainUser, ...}:
with lib;
let
  cfg = config.modules.work;
in 
{
  options.modules.work = {
    vpn = {
      enable = mkEnableOption "enable work vpn";
    };
  };

  config = mkIf cfg.vpn.enable {
    security.polkit.enable = true;
    security.pki.certificateFiles = [
      "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    ];
    security.pki.certificates = [
      "/home/${mainUser}/certs/Vakhtang-Pavliashvili.pem"
      "/home/${mainUser}/certs/Vakhtang-Pavliashvili.crt"
    ];

    environment.systemPackages = [
      pkgs.openssl
      pkgs.p11-kit
      pkgs.openconnect
      pkgs.vpnc-scripts
    ];
  };
}
