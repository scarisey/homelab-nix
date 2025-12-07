{
  config,
  lib,
  libProxy,
  pkgs,
  ...
}: let
  enabled = config.scarisey.homelab.enable;
in {
  config = lib.mkIf enabled (let
    cfg = config.scarisey.homelab;
    inherit (config.scarisey.homelab.settings) email lanPort wanPort domains;
    declareVirtualHostDefaults = libProxy.declareVirtualHostDefaults cfg;
    declareCerts = libProxy.declareCerts cfg;
    geoipDb = "/var/lib/GeoIP";
    inherit (config.scarisey.homelab.settings.geoip) maxmindAccountId maxmindLicenseKeyFile;
  in {
    services.nginx = {
      enable = true;

      package = pkgs.nginx.override {
        modules = [
          pkgs.nginxModules.geoip2
        ];
      };

      statusPage = true;

      appendHttpConfig = ''
        limit_conn_zone $binary_remote_addr zone=conn_limit_per_ip:10m;
        limit_req_zone $binary_remote_addr zone=req_limit_per_ip:10m rate=10r/s;

        geoip2 ${geoipDb}/GeoLite2-Country.mmdb {
          auto_reload 60m;
          $geoip2_metadata_country_build metadata build_epoch;

          # Map the country ISO code to a variable
          $geoip2_data_country_code default=XX source=$remote_addr country iso_code;
          $geoip2_data_country_name country names en;
        }

        geo $is_private_ip {
          default 0;
          10.0.0.0/8 1;
          172.16.0.0/12 1;
          192.168.0.0/16 1;
          127.0.0.0/8 1;
        }
        geoip2 ${geoipDb}/GeoLite2-City.mmdb {
          $geoip2_data_city_name default=London city names en;
        }

        map $geoip2_data_country_code $allowed_country {
            default 0;
            "" 1;
            FR 1;
        }

        map "$is_private_ip:$allowed_country" $block_request {
          default 1;        # Block by default
          "1:1" 0;          # Private IP + not blocked country = allow
          "1:0" 0;          # Private IP + blocked country = allow (private takes precedence)
          "0:1" 0;          # Public IP + not blocked country = allow
          "0:0" 1;          # Public IP + blocked country = BLOCK
        }

        log_format json_analytics escape=json '{'
                              '"msec": "$msec", ' # request unixtime in seconds with a milliseconds resolution
                              '"connection": "$connection", ' # connection serial number
                              '"connection_requests": "$connection_requests", ' # number of requests made in connection
                      '"pid": "$pid", ' # process pid
                      '"request_id": "$request_id", ' # the unique request id
                      '"request_length": "$request_length", ' # request length (including headers and body)
                      '"remote_addr": "$remote_addr", ' # client IP
                      '"remote_user": "$remote_user", ' # client HTTP username
                      '"remote_port": "$remote_port", ' # client port
                      '"time_local": "$time_local", '
                      '"time_iso8601": "$time_iso8601", ' # local time in the ISO 8601 standard format
                      '"request": "$request", ' # full path no arguments if the request
                      '"request_uri": "$request_uri", ' # full path and arguments if the request
                      '"args": "$args", ' # args
                      '"status": "$status", ' # response status code
                      '"body_bytes_sent": "$body_bytes_sent", ' # the number of body bytes exclude headers sent to a client
                      '"bytes_sent": "$bytes_sent", ' # the number of bytes sent to a client
                      '"http_referer": "$http_referer", ' # HTTP referer
                      '"http_user_agent": "$http_user_agent", ' # user agent
                      '"http_x_forwarded_for": "$http_x_forwarded_for", ' # http_x_forwarded_for
                      '"http_host": "$http_host", ' # the request Host: header
                      '"server_name": "$server_name", ' # the name of the vhost serving the request
                      '"request_time": "$request_time", ' # request processing time in seconds with msec resolution
                      '"upstream": "$upstream_addr", ' # upstream backend server for proxied requests
                      '"upstream_connect_time": "$upstream_connect_time", ' # upstream handshake time incl. TLS
                      '"upstream_header_time": "$upstream_header_time", ' # time spent receiving upstream headers
                      '"upstream_response_time": "$upstream_response_time", ' # time spend receiving upstream body
                      '"upstream_response_length": "$upstream_response_length", ' # upstream response length
                      '"upstream_cache_status": "$upstream_cache_status", ' # cache HIT/MISS where applicable
                      '"ssl_protocol": "$ssl_protocol", ' # TLS protocol
                      '"ssl_cipher": "$ssl_cipher", ' # TLS cipher
                      '"scheme": "$scheme", ' # http or https
                      '"request_method": "$request_method", ' # request method
                      '"server_protocol": "$server_protocol", ' # request protocol, like HTTP/1.1 or HTTP/2.0
                      '"pipe": "$pipe", ' # "p" if request was pipelined, "." otherwise
                      '"gzip_ratio": "$gzip_ratio", '
                      '"http_cf_ray": "$http_cf_ray",'
                      '"geoip_country_code": "$geoip2_data_country_code",'
                      '"geoip_country_name": "$geoip2_data_country_name",'
                      '}';

        access_log /var/log/nginx/json_access.log json_analytics;
        access_log /var/log/nginx/access.log combined;

        set_real_ip_from 192.168.0.0/16;
        real_ip_header X-Forwarded-For;
      '';

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      proxyTimeout = "600s";

      # Only allow PFS-enabled ciphers with AES256
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

      virtualHosts."localhost" = {
        listen = [
          {
            addr = "127.0.0.1";
            port = 9113;
          }
        ];
        locations."/nginx_status" = {
          extraConfig = ''
            stub_status;
            allow 127.0.0.1;
            deny all;
          '';
        };
      };

      virtualHosts.${domains.root} =
        declareVirtualHostDefaults {
          domain = domains.root;
          localOnly = true;
        }
        // {
          locations."/" = {
            return = "200 '<html><body>It works</body></html>'";
            extraConfig = ''
              default_type text/html;
              #basic ddos protection
              limit_req zone=req_limit_per_ip;
              limit_conn conn_limit_per_ip 2;
            '';
          };
        };

      virtualHosts.${domains.internal} =
        declareVirtualHostDefaults {
          domain = domains.internal;
          localOnly = true;
        }
        // {
          locations."/" = {
            return = "200 '<html><body>It works</body></html>'";
            extraConfig = ''
              default_type text/html;
              #basic ddos protection
              limit_req zone=req_limit_per_ip;
              limit_conn conn_limit_per_ip 2;
            '';
          };
        };
    };
    users.users.nginx.extraGroups = ["acme"];

    services.geoipupdate = {
      enable = true;
      settings = {
        # Replace with your actual MaxMind Account ID and License Key
        AccountID = maxmindAccountId;
        LicenseKey = maxmindLicenseKeyFile;
        # valid edition IDs: "GeoLite2-City", "GeoLite2-Country", "GeoLite2-ASN"
        EditionIDs = ["GeoLite2-Country" "GeoLite2-City"];
        # Explicitly set the directory so we can reference it in Nginx
        DatabaseDirectory = geoipDb;
      };
      # Update interval (e.g., weekly)
      interval = "weekly";
    };

    security.acme.acceptTerms = true;
    security.acme.defaults.email = email;

    security.acme.certs.${domains.root} = declareCerts domains.root;
    security.acme.certs.${domains.internal} = declareCerts domains.wildcardInternal;

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [lanPort wanPort];
    };
  });
}
