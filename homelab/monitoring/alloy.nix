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
    environment.etc."alloy/config.alloy".source =  ./config.alloy;

    system.activationScripts.setAlloyACLs = {
      text = ''
        ${pkgs.acl}/bin/setfacl -dR -m u:alloy:rx /var/log/nginx
        ${pkgs.acl}/bin/setfacl -R -m u:alloy:rx /var/log/nginx
        ${pkgs.acl}/bin/setfacl -R -m u:alloy:r /var/log/nginx/access*.log
      '';
    };
  };
}
