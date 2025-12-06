{
  lib,
  config,
  ...
}: let
  cfg = config.scarisey.homelab;
  customDomainType = with lib;
    types.submodule {
      options = {
        domain = mkOption {
          type = types.str;
          description = "Full domain for this service.";
        };
        proxyPass = mkOption {
          type = types.str;
          description = "URL to the service (localhost).";
        };
        proxyWebsockets = mkOption {
          type = types.bool;
          default = false;
          description = "Activate Web Sockets for this domain.";
        };
        extraConfig = mkOption {
          type = types.str;
          default = "";
          description = "Extra config for nginx current virutal host.";
        };
      };
    };
  textfileCollectorType = with lib;
    types.submodule {
      options = {
        path = mkOption {
          type = types.str;
          description = "Path to the file that will be collected by the exporter.";
          default = "/var/lib/node_exporter/textfile_collector";
        };
        flakeRevisionPath = mkOption {
          type = types.str;
          description = "Path to the file containing the actual flake's git revision.";
          default = "/etc/flake-revision";
        };
        publicFlakeUrl = mkOption {
          type = types.str;
          description = "Url to the public flake repository.";
        };
      };
    };
in
  with lib; {
    scarisey.homelab = {
      enable = mkEnableOption "Server settings";
      user = lib.mkOption {
        type = lib.types.str;
        default = "homelab";
        description = "User account under which homelab apps can refer to.";
      };
      userId = lib.mkOption {
        type = lib.types.int;
        default = 981;
        description = "User account ID under which homelab apps can refer to.";
      };
      group = lib.mkOption {
        type = lib.types.str;
        default = "homelab";
        description = "Group account under which homelab apps can refer to.";
      };
      groupId = lib.mkOption {
        type = lib.types.int;
        default = 971;
        description = "Group account ID under which homelab apps can refer to.";
      };
      settings.email = mkOption {
        type = types.str;
        description = "Email address used by Let's Encrypt.";
      };
      settings.ipv4 = mkOption {
        type = types.str;
        description = "IPv4 in your LAN where the server is.";
      };
      settings.ipv6 = mkOption {
        type = types.str;
        description = "IPv6 in your LAN where the server is.";
      };
      settings.wanPort = mkOption {
        type = types.port;
        description = "If your server is behing a NAT, port by which the Internet traffic comes from.";
      };
      settings.lanPort = mkOption {
        type = types.port;
        description = "If your server is behing a NAT, port by which the LAN traffic comes from.";
      };
      settings.domains = mkOption {
        description = "Domains declaration.";
        default = {};
        type = types.submodule {
          options = {
            root = mkOption {
              type = types.str;
              description = "Shared root domain by all domains declared.";
            };
            internal = mkOption {
              type = types.str;
              description = "Used prefix for internal domains.";
              default = "internal.${cfg.settings.domains.root}";
            };
            wildcardInternal = mkOption {
              type = types.str;
              description = "Wild internal domain to generate a common SSL certificate.";
              default = "*.${cfg.settings.domains.internal}";
            };
            grafana = mkOption {
              type = types.str;
              description = "grafana domain, will be exposed on LAN and WAN by default.";
              default = "grafana.${cfg.settings.domains.root}";
            };
            lan = mkOption {
              type = types.attrsOf customDomainType;
              default = {};
              description = "Attribute set of domains accessible only on LAN.";
            };
            public = mkOption {
              type = types.attrsOf customDomainType;
              default = {};
              description = "Attribute set of domains accessible on LAN and WAN.";
            };
          };
        };
      };
      settings.blocky = mkOption {
        description = "Blocky settings to merge to defaults.";
        default = {};
        type = types.attrsOf types.anything;
      };
      settings.grafana = mkOption {
        description = "Grafana settings to merge to defaults.";
        default = {};
        type = types.attrsOf types.anything;
      };
      settings.acme = mkOption {
        description = "Acme settings to merge to defaults.";
        default = {};
        type = types.attrsOf types.anything;
      };
      settings.geoip = {
        maxmindAccountId = mkOption {
          description = "Maxmind account id to fetch db for geoip2.";
          type = types.int;
        };
        maxmindLicenseKeyFile = mkOption {
          description = "Maxmind license key to fetch db for geoip2.";
          type = types.path;
        };
      };
      settings.postgresql.postscripts = mkOption {
        description = "Scripts that will be played after postsql start. Should be idempotent.";
        default = {};
        example = {db1 = "/scriptDb1.sql";};
        type = types.attrsOf types.str;
      };
      backups.enable = mkEnableOption "Enable backups.";
      backups.groups = mkOption {
        description = "Groups that backup utility should be part of.";
        default = [];
        type = types.listOf types.str;
      };
      backups.repository.name = mkOption {
        description = "Repository name.";
        default = "${host}-backup";
        type = types.str;
      };
      backups.repository.url = mkOption {
        description = "Where the repository should be backed up.";
        type = types.str;
      };
      backups.repository.environmentFile = mkOption {
        description = "Path to environmentFile (systemd unit env file) in string.";
        type = types.str;
      };
      backups.repository.passwordFile = mkOption {
        description = "Path to passwordFile in string, to decrypt repository.";
        type = types.str;
      };
      backups.repository.locations = mkOption {
        description = "Paths to locations to backup in string.";
        type = types.listOf types.str;
      };
      textfileCollector = mkOption {
        description = "Collect manually computed prometheus metrics. Actually contains only flake revision.";
        type = textfileCollectorType;
      };
    };
  }
