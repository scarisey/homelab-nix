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
        host    all             all             127.0.0.1/32            scram-sha-256
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
  });
}
