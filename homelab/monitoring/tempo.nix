{
  config,
  lib,
  ...
}: let
  enabled = config.scarisey.homelab.enable;
in {
  config = lib.mkIf enabled {
    services.tempo = {
      enable = true;

      settings = {
        server = {
          http_listen_port = 3200;
          grpc_listen_port = 9097;
        };

        distributor = {
          receivers = {
            otlp = {
              protocols = {
                grpc = {
                  endpoint = "127.0.0.1:9096";
                };
              };
            };
          };
        };

        storage = {
            trace = {
                backend = "local";
                local = {
                    path = "/var/lib/tempo/blocks";
                };
                wal.path = "/var/lib/tempo/wal";
            };
        };

        compactor = {
          compaction = {
            block_retention = "744h";
          };
        };
      };
    };
  };
}
