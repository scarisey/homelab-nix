# Homelab Nix Module

This module provides a comprehensive, opinionated set of NixOS services for running a self-hosted homelab, including networking, monitoring, logging, security, and proxying. It is designed to be imported as a module in your NixOS configuration and exposes a set of options for customization.

## Usage

Import the module in your NixOS configuration:

```nix
{
  imports = [
    ./homelab
  ];

  scarisey.homelab = {
    enable = true;
    settings = {
      email = "your@email.com";
      ipv4 = "192.168.1.10";
      ipv6 = "fd00::10";
      wanPort = 443;
      lanPort = 8443;
      domains = {
        root = "example.com";
        internal = "internal.example.com";
        wildcardInternal = "*.internal.example.com";
        grafana = "grafana.example.com";
        lan = {
          # LAN-only services
          myservice = {
            domain = "service.internal.example.com";
            proxyPass = "http://localhost:8080";
            proxyWebsockets = true;
            extraConfig = ''
              client_max_body_size 8196M;
            '';
          };
        };
        public = {
          # Publicly exposed services
          blog = {
            domain = "blog.example.com";
            proxyPass = "http://localhost:8081";
          };
        };
      };
      blocky = {};
      grafana = {};
      postgresql.postscripts = {
        db1 = "/path/to/scriptDb1.sql";
      };
    };
  };
}
```

## Module Options

All options are under `scarisey.homelab`:

- **enable**: (bool) Enable the homelab stack.
- **settings.email**: (string) Email for Let's Encrypt and ACME.
- **settings.ipv4**: (string) LAN IPv4 address of your server.
- **settings.ipv6**: (string) LAN IPv6 address of your server.
- **settings.wanPort**: (int) WAN port (e.g., 443) for NAT/Internet traffic.
- **settings.lanPort**: (int) LAN port for local-only traffic.
- **settings.domains**:
  - **root**: (string) The base/root domain for your services.
  - **internal**: (string) Prefix for internal domains. Defaults to `internal.${root}`.
  - **wildcardInternal**: (string) Wildcard for internal SSL certs. Defaults to `*.${internal}`.
  - **grafana**: (string) Domain for Grafana. Defaults to `grafana.${root}`.
  - **lan**: (attrs) LAN-only domains. Each entry is `{ domain, proxyPass, proxyWebsockets, extraConfig }`.
  - **public**: (attrs) Public domains. Each entry is `{ domain, proxyPass, proxyWebsockets, extraConfig }`.
- **settings.blocky**: (attrs) Override/extend default Blocky DNS settings.
- **settings.grafana**: (attrs) Override/extend default Grafana settings.
- **settings.postgresql.postscripts**: (attrs) Postgres scripts to run after startup. Example: `{ db1 = "/scriptDb1.sql"; }`.

## Services Provided & How They Work Together

The module orchestrates the following services:

- **Nginx** (reverse proxy): Handles HTTP(S) traffic for all domains, manages certificates via ACME/Let's Encrypt, and proxies to internal services.
- **Blocky** (DNS): Local DNS resolver with custom mappings for LAN/public domains, integrated with Prometheus for metrics and PostgreSQL for query logs.
- **Fail2ban** (security): Protects Nginx from brute-force and bad bots via log-based banning.
- **PostgreSQL**: Used as a backend for Blocky logs and optionally for user data (e.g., Grafana).
- **Prometheus**: Collects metrics from services (Nginx, system, Blocky, etc.).
- **Grafana**: Visualizes metrics from Prometheus and logs from Loki.
- **Loki**: Aggregates logs from Nginx and other services.
- **Alloy**: Collects and processes logs for observability, with ACLs for Nginx logs.

### Integration Flow
- **Nginx** proxies requests to internal/public services based on domain config, secured by ACME certificates.
- **Blocky** provides DNS for all declared domains, logs queries to PostgreSQL, and exposes metrics to Prometheus.
- **Fail2ban** monitors Nginx logs for abuse and bans offending IPs.
- **Prometheus** scrapes exporters and Blocky for metrics.
- **Grafana** is pre-configured with Prometheus and Loki as datasources.
- **Loki** stores and serves logs, accessible from Grafana.
- **Alloy** ensures logs are accessible and processed for observability.

## Extending & Customizing
- You can override settings for Blocky and Grafana via `settings.blocky` and `settings.grafana`.
- Add custom domains/services under `settings.domains.lan` or `settings.domains.public`.
- Add post-start scripts for PostgreSQL via `settings.postgresql.postscripts`.

## Requirements
- NixOS 23.11 or later recommended.
- Proper DNS and firewall configuration for your chosen domains and ports.

---

For more details, see each service's Nix file in the `homelab/` directory.

