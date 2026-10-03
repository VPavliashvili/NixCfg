{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.auth;
in {
  options.modules.auth.enableAuthelia = mkEnableOption "enable authelia for this host (usage only expected by rivendell)";

  config = mkIf cfg.enableAuthelia {
    services.authelia.instances.main = {
      enable = true;

      secrets = {
        jwtSecretFile = config.age.secrets.authelia-jwt.path;
        sessionSecretFile = config.age.secrets.authelia-session.path;
        storageEncryptionKeyFile = config.age.secrets.authelia-storage.path;
      };

      settings = {
        theme = "dark";
        server.address = "tcp://127.0.0.1:9091";
        log.level = "info";

        access_control = {
          default_policy = "deny";
          rules = [
            {
              domain = ["seerr.esgalmar.net"];
              policy = "two_factor";
            }
          ];
        };

        # issuer is the string which appears
        # inside auth app as a service name
        totp.issuer = "esgalmar.net";
        # only using totp so webauthn will be
        # appeared and take space in webui when
        # in reality it is not implemented
        # for this reason setting it to disabled
        webauthn.disable = true;

        session = {
          name = "authelia_session";
          expiration = "30 minutes";
          inactivity = "15 minutes";
          remember_me = "1 year";
          cookies = [
            {
              domain = "esgalmar.net";
              authelia_url = "https://auth.esgalmar.net";
            }
          ];
        };

        storage.local.path = "/var/lib/authelia-main/db.sqlite3";

        notifier.smtp = {
          address = "submission://mail-eu.smtp2go.com:587";
          username = "esgalmar-authelia";
          sender = "esgalmar <auth@esgalmar.net>";
        };

        authentication_backend.ldap = {
          implementation = "lldap";
          address = "ldap://127.0.0.1:3890";
          base_dn = "dc=esgalmar,dc=net";
          user = "uid=admin,ou=people,dc=esgalmar,dc=net";
        };
      };
    };

    systemd.services."authelia-main".serviceConfig.EnvironmentFile = [
      (pkgs.writeText "authelia-ldap-env" ''
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE=${config.age.secrets.lldap-admin-pass.path}
        AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE=${config.age.secrets.authelia-smtp.path}
      '')
    ];

    age.secrets = {
      authelia-jwt = {
        file = ../../../../secrets/authelia-jwt.age;
        owner = "authelia-main";
        group = "authelia-main";
      };
      authelia-session = {
        file = ../../../../secrets/authelia-session.age;
        owner = "authelia-main";
        group = "authelia-main";
      };
      authelia-storage = {
        file = ../../../../secrets/authelia-storage.age;
        owner = "authelia-main";
        group = "authelia-main";
      };
      authelia-smtp = {
        file = ../../../../secrets/authelia-smtp.age;
        owner = "authelia-main";
        group = "authelia-main";
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/authelia-main 0750 authelia-main authelia-main -"
    ];
  };
}
