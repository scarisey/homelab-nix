{ config, lib, pkgs, ... }:
let
  crowdsec-port = 8057;
  mkAcquisition = unit: {
        source = "journalctl";
        journalctl_filter = [ "_SYSTEMD_UNIT=${unit}" ];
        labels.type = "syslog";
      }
    ;
  cfg = config.scarisey.homelab.settings.crowdsec;
  crowdsec-enroll-key = cfg.enrollKeyFile;
  inspectedServices = cfg.inspectServices;
in {
  services.crowdsec = {
    enable = true;
    enrollKeyFile = crowdsec-enroll-key;
    allowLocalJournalAccess = true;
    acquisitions = builtins.filter (v: v != null) (builtins.map (v: mkAcquisition v) inspectedServices );
    settings = {
      api.server = {
        listen_uri = "127.0.0.1:${toString crowdsec-port}";
      };
    };
  };

  services.crowdsec-firewall-bouncer = {
    enable = true;
    settings = {
      api_url = "http://127.0.0.1:${toString crowdsec-port}";
      api_key = "cs-firewall-bouncer";
    };
  };

  systemd.services.crowdsec = {
    # Fix journald parsing error
    environment = {
      LANG = "C.UTF-8";
    };
    postStart = ''
      while ! cscli lapi status; do
        echo "Waiting for CrowdSec daemon to be ready"
        sleep 5
      done

      cscli bouncers add cs-firewall-bouncer --key cs-firewall-bouncer || true
    '';
    serviceConfig = {
      ExecStartPre = lib.mkAfter [
        (pkgs.writeShellScript "crowdsec-packages" ''
          cscli hub upgrade

          cscli collections install \
            crowdsecurity/sshd

          cscli postoverflows install \
            crowdsecurity/cdn-whitelist \
            crowdsecurity/discord-crawler-whitelist \
            crowdsecurity/ipv6_to_range \
            crowdsecurity/rdns \
            crowdsecurity/seo-bots-whitelist
        '')
      ];

      StateDirectory = "crowdsec";
      Restart = lib.mkForce "always";
      RestartSec = lib.mkForce "5";
    };
  };

  systemd.services.crowdsec-firewall-bouncer =
    lib.mkIf config.services.crowdsec-firewall-bouncer.enable
      {
        after = [ "crowdsec.service" ];
        requires = [ "crowdsec.service" ];
        serviceConfig = {
          Restart = lib.mkForce "always";
          RestartSec = lib.mkForce "5";
        };
      };
}
