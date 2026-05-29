{
  pkgs,
  config,
  lib,
  ...
}: let
  enabled = config.scarisey.homelab.enable;
in {
  config = lib.mkIf enabled (let
    cfg = config.scarisey.homelab;
    postgreCfg = config.services.postgresql;
  in {
    services.postgresql = {
      enable = true;

      package = pkgs.postgresql_17;
      authentication = ''
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             all                                     peer
        hostssl all             all             127.0.0.1/32            scram-sha-256
      '';

      settings = {
        listen_addresses = "localhost";
        password_encryption = "scram-sha-256";
        log_connections = true;
        log_disconnections = true;
        log_statement = "none";
        log_line_prefix = "%m [%p] %u@%d ";
        client_min_messages = "notice";
        shared_buffers = "512MB";
        jit = true;
        track_io_timing = true;

        ssl = true;
        ssl_cert_file = "${config.security.acme.certs."postgres.${cfg.settings.domains.internal}".directory}/fullchain.pem";
        ssl_key_file = "${config.security.acme.certs."postgres.${cfg.settings.domains.internal}".directory}/key.pem";
      };
    };

    systemd.services."homelab-postgresql-postscript" = {
      serviceConfig.Type = "oneshot";
      after = ["postgresql.service"];
      serviceConfig.User = "postgres";
      environment.PSQL = "psql --port=${toString postgreCfg.settings.port}";
      path = [pkgs.postgresql];
      script = builtins.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "$PSQL ${k} -f ${v}") cfg.settings.postgresql.postscripts);
    };

    systemd.services."homelab-postgresql-permissions" = {
      requiredBy = ["postgresql.service"];
      before = ["postgresql.service"];
      serviceConfig.Type = "oneshot";
      script = ''
        chown postgres:postgres /var/lib/acme/postgres.${cfg.settings.domains.internal}/*
        chmod 0400 /var/lib/acme/postgres.${cfg.settings.domains.internal}/*
      '';
    };
    systemd.services."acme-pre-postgres" = {
        before = ["acme-order-renew-postgres.${cfg.settings.domains.internal}.service"];
        requiredBy = ["acme-order-renew-postgres.${cfg.settings.domains.internal}.service"];
        serviceConfig.Type = "oneshot";
        path = [pkgs.findutils];
        script = ''
          chown -R acme:postgres /var/lib/acme/postgres.${cfg.settings.domains.internal}/
          find /var/lib/acme/postgres.${cfg.settings.domains.internal}/ -type d -exec chmod 0750 {} \;
          find /var/lib/acme/postgres.${cfg.settings.domains.internal}/ -type f -exec chmod 0640 {} \;
        '';
    };
    security.acme.certs."postgres.${cfg.settings.domains.internal}" = {
        domain = cfg.settings.domains.wildcardInternal;
        #check https://go-acme.github.io/lego/dns/
        dnsProvider = cfg.settings.acme.dnsProvider;
        dnsPropagationCheck = true;
        environmentFile = cfg.settings.acme.environmentFile;
        group = "postgres";
        postRun = ''
          chown postgres:postgres /var/lib/acme/postgres.${cfg.settings.domains.internal}/*
          chmod 0400 /var/lib/acme/postgres.${cfg.settings.domains.internal}/*
        '';
    };
  });
}
