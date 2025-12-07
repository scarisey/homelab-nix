{lib, ...}: {
  _module.args = {
    libProxy = let
      declareCerts = cfg: domain: {
        inherit domain;
        #check https://go-acme.github.io/lego/dns/
        dnsProvider = cfg.settings.acme.dnsProvider;
        dnsPropagationCheck = true;
        environmentFile = cfg.settings.acme.environmentFile;
        group = "acme";
      };

      declareVirtualHostDefaults = cfg: {
        domain,
        localOnly ? false,
      }: let
        ipv4 = cfg.settings.ipv4;
        lanPort = cfg.settings.lanPort;
        wanPort = cfg.settings.wanPort;
        ifLocalListen = localOnly:
          [
            {
              addr = ipv4;
              port = lanPort;
              ssl = true;
            }
          ]
          ++ (
            if localOnly
            then []
            else [
              {
                addr = ipv4;
                port = wanPort;
                ssl = true;
              }
            ]
          );
      in {
        listen = ifLocalListen localOnly;
        http2 = true;
        useACMEHost =
          if localOnly
          then cfg.settings.domains.internal
          else domain;
        forceSSL = true;
      };
      _automaticVirtualHosts = conf: {
        localOnly ? false,
        _domains,
      }:
        lib.mapAttrs' (k: v: {
          name = "${v.domain}";
          value =
            (declareVirtualHostDefaults conf {
              domain = v.domain;
              inherit localOnly;
            })
            // {
              locations."/".proxyPass = v.proxyPass;
              locations."/".proxyWebsockets = v.proxyWebsockets;
              locations."/".extraConfig = ''
                add_header X-Country-Code $geoip2_data_country_code;

                if ($block_request) {
                  return 403;
                }

                ${v.extraConfig}
              '';
            };
        })
        _domains;
      automaticVirtualHosts = conf:
        (_automaticVirtualHosts conf {
          localOnly = true;
          _domains = conf.settings.domains.lan;
        })
        // (_automaticVirtualHosts conf {_domains = conf.settings.domains.public;});
      automaticDeclareCerts = conf:
        lib.mapAttrs' (k: v: {
          name = v.domain;
          value = declareCerts conf v.domain;
        }) (
          conf.settings.domains.public
          // conf.settings.domains.lan
        );
    in {
      inherit declareCerts declareVirtualHostDefaults automaticVirtualHosts automaticDeclareCerts;
    };
  };
}
