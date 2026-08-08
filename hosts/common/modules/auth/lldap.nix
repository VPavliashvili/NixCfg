{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.auth;
in {
  options.modules.auth.enableLldap = mkEnableOption "enable lldap (usage is expected with authelia)";

  config = mkIf cfg.enableLldap {
    users.users.lldap = {
      isSystemUser = true;
      group = "lldap";
    };
    users.groups.lldap = {};

    systemd.services.lldap.serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = lib.mkForce "lldap";
      Group = lib.mkForce "lldap";
    };

    services.lldap = {
      enable = true;
      settings = {
        ldap_base_dn = "dc=esgalmar,dc=net";
        ldap_host = "127.0.0.1";
        ldap_port = 3890;
        http_host = "0.0.0.0";
        http_port = 17170;
        database_url = "sqlite:///var/lib/lldap/main.db?mode=rwc";
        force_ldap_user_pass_reset = "always";
      };
      environment = {
        LLDAP_JWT_SECRET_FILE = config.age.secrets.lldap-jwt.path;
        LLDAP_LDAP_USER_PASS_FILE = config.age.secrets.lldap-admin-pass.path;
      };
    };

    age.secrets = {
      lldap-jwt = {
        file = ../../../../secrets/lldap-jwt.age;
        owner = "lldap";
        group = "lldap";
      };
      lldap-admin-pass = {
        file = ../../../../secrets/lldap-admin-pass.age;
        owner = "lldap";
        group = "authelia-main"; # also used as Authelia's LDAP bind password
        mode = "0440";
      };
    };

    networking.firewall.allowedTCPPorts = [17170];
  };
}
