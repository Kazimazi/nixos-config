{ config, lib, pkgs, ... }:

{
  config = {
    services.nextcloud = {
      enable = true;
      hostName = "nextcloud.tld";
      https = false; # BUG? why can't I use it?
      config = {
        dbtype = "pgsql";
        dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
        adminpass = "secret";
        extraTrustedDomains = ["192.168.0.10"];
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [
        { name = "nextcloud";
          ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
        }
      ];
    };

    # ensure that postgres is running *before* running the setup
    systemd.services."nextcloud-setup" = {
      requires = ["postgresql.service"];
      after = ["postgresql.service"];
    };

    security.sudo.enable = true; # HACK shouldn't be NEEDED - check later

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    environment.systemPackages = with pkgs; [nextcloud-client];
  };
}
