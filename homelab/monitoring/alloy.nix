{
  config,
  pkgs,
  lib,
  ...
}: let
  enabled = config.scarisey.homelab.enable;
in {
  config = lib.mkIf enabled {
    services.alloy.enable = true;
    # services.alloy.extraFlags = [
    #   "--server.http.listen-addr=127.0.0.1:9200"
    #   "--stability.level"
    #   "experimental"
    # ];
    # should also enable live debugging
    environment.etc."alloy/config.alloy".text = ''
        logging {
          level = "info"
        }

        loki.write "local" {
          endpoint {
            url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push"
          }
        }

        local.file_match "nginx_logs" {
          path_targets = [
            {"__path__" = "/var/log/nginx/json_access.log","job"="nginx","hostname" = constants.hostname},
          ]
          sync_period = "5s"
        }

        loki.source.file "nginx" {
          targets    = local.file_match.nginx_logs.targets
          forward_to = [loki.write.local.receiver]
        }

        local.file_match "fail2ban_logs" {
          path_targets = [
            {"__path__" = "/var/log/fail2ban.log","job"="fail2ban","hostname" = constants.hostname},
          ]
          sync_period = "5s"
        }

        loki.source.file "fail2ban" {
          targets = local.file_match.fail2ban_logs.targets
          forward_to = [loki.write.local.receiver]
        }

        loki.process "fail2ban" {
          forward_to = [prometheus.scrape.fail2ban.receiver]

          stage.regex {
            expression = ".*\\[(?P<jail>[^\\]]+)\\] (?P<action>Ban|Unban) (?P<ip>[^ ]+)"
          }

          stage.metrics {
            counter "fail2ban_bans_total" {
              description = "Number of bans"
              source = "action"
              match  = "Ban"
              action = "inc"
              labels = {
                jail = "{{ .jail }}",
                ip   = "{{ .ip }}",
              }
            }

            counter "fail2ban_unbans_total" {
              description = "Number of unbans"
              source = "action"
              match  = "Unban"
              action = "inc"
              labels = {
                jail = "{{ .jail }}",
                ip   = "{{ .ip }}",
              }
            }
          }
        }

      prometheus.exporter.process "fail2ban" {
        matcher {
          name    = "fail2ban"
          cmdline = [".*"]
        }
      }

      prometheus.scrape "fail2ban" {
        targets    = prometheus.exporter.process.fail2ban.targets
        forward_to = [prometheus.remote_write.to_prom.receiver]
      }

      prometheus.remote_write "to_prom" {
        endpoint {
            url = "http://127.0.0.1:9091/api/v1/write"
        }
      }
    '';

    system.activationScripts.setAlloyACLs = {
      text = ''
        ${pkgs.acl}/bin/setfacl -dR -m u:alloy:rx /var/log/nginx
        ${pkgs.acl}/bin/setfacl -R -m u:alloy:rx /var/log/nginx
        ${pkgs.acl}/bin/setfacl -R -m u:alloy:r /var/log/nginx/access*.log
      '';
    };
  };
}
