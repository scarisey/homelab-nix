{
  config,
  lib,
  ...
}: let
  enabled = config.scarisey.homelab.enable;
in {
  config = lib.mkIf enabled (
    let
      cfg = config.scarisey.homelab; #avoid infinite recursion on resolution
    in {
      users.users = lib.mkIf (cfg.user == "homelab") {
        homelab = {
          isSystemUser = true;
          group = cfg.group;
          uid = cfg.userId;
        };
      };
      users.groups = lib.mkIf (cfg.group == "homelab") {
        homelab = {
          gid = cfg.groupId;
        };
      };
    }
  );
}
