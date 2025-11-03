{
  config,
  lib,
  pkgs,
  ...
}:let
  cfg = config.scarisey.homelab.backups;
in lib.mkIf (cfg.enable) ({
  users.users.restic = {
    isNormalUser = true;
    extraGroups = [ config.scarisey.homelab.group ] ++ cfg.groups;
  };

  security.wrappers.restic = {
    source = "${pkgs.restic}/bin/restic";
    owner = "restic";
    group = config.scarisey.homelab.group;
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  services.restic.backups.${cfg.repository.name} = {
    repository = cfg.repository.url;
    environmentFile = cfg.repository.environmentFile;
    passwordFile = cfg.repository.passwordFile;
    initialize = true;
    user = "restic";
    paths = cfg.repository.locations;
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    pruneOpts = [
      "--keep-last 3"
    ];
    package = pkgs.writeShellScriptBin "restic-wrapper" ''
      exec /run/wrappers/bin/restic "$@"
    '';
  };
})
