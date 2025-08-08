{
  config,
  lib,
  libProxy,
  ...
}: let
  enabled = config.scarisey.homelab.enable;
in {
  config = lib.mkIf enabled (
    let
      cfg = config.scarisey.homelab;
      inherit (libProxy) automaticDeclareCerts automaticVirtualHosts;
    in {
      security.acme.certs = automaticDeclareCerts cfg;
      services.nginx.virtualHosts = automaticVirtualHosts cfg;
    }
  );
}
