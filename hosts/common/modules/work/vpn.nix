{
  lib,
  config,
  pkgs,
  mainUser,
  ...
}:
with lib; let
  cfg = config.modules.work;
in {
  options.modules.work = {
    vpn = {
      enable = mkEnableOption "enable work vpn";
    };
  };

  config = mkIf cfg.vpn.enable {
    age.secrets.liberty-password = {
      file = ../../../../secrets/liberty-password.age;
      owner = mainUser;
      mode = "0400";
    };
    age.secrets.liberty-cert-pwd = {
      file = ../../../../secrets/liberty-cert-pwd.age;
      owner = mainUser;
      mode = "0400";
    };
    age.secrets.liberty-cert-pfx = {
      file = ../../../../secrets/liberty-cert-pfx.age;
      owner = mainUser;
      mode = "0444";
    };

    system.activationScripts.extractCerts = {
      text = ''
        cert_pwd=$(cat ${config.age.secrets.liberty-cert-pwd.path})
        pfx_path="${config.age.secrets.liberty-cert-pfx.path}"

        mkdir -p /run/certs

        # extract pem
        ${pkgs.openssl}/bin/openssl pkcs12 \
          -in "$pfx_path" \
          -nocerts \
          -out /run/certs/liberty-cert.pem \
          -nodes \
          -passin pass:$cert_pwd

        # extract crt
        ${pkgs.openssl}/bin/openssl pkcs12 \
          -in "$pfx_path" \
          -nokeys \
          -out /run/certs/liberty-cert.crt \
          -nodes \
          -passin pass:$cert_pwd

        chmod 644 /run/certs/*.pem /run/certs/*.crt
      '';
      deps = ["agenixInstall"];
    };

    security = {
      polkit.enable = true;
      pki = {
        certificateFiles = [
          "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        ];
        certificates = [
          "/run/certs/liberty-cert.pem"
          "/run/certs/liberty-cert.crt"
        ];
      };
    };

    environment.systemPackages = [
      pkgs.openssl
      pkgs.p11-kit
      pkgs.openconnect
      pkgs.vpnc-scripts
      (pkgs.writeShellScriptBin "connectwork" ''
        pwd=$(cat ${config.age.secrets.liberty-password.path})
        cert_pwd=$(cat ${config.age.secrets.liberty-cert-pwd.path})
        pfx_path="${config.age.secrets.liberty-cert-pfx.path}"

        # extractring --servercert
        pin=$(echo "no" | openconnect \
          -s vpnc-script \
          -c $pfx_path \
          https://vpn.lb.ge/dev \
          --user=v.pavliashvili \
          --passwd-on-stdin \
          --key-password=$cert_pwd 2>&1 | grep -oP 'pin-sha256:\S+')

        echo $pwd | openconnect \
          -s vpnc-script \
          -c $pfx_path \
          https://vpn.lb.ge/dev \
          --user=v.pavliashvili \
          --passwd-on-stdin \
          --servercert $pin \
          --key-password=$cert_pwd
      '')
    ];
  };
}
