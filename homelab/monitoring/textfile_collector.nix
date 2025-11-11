{
  config,
  pkgs,
  lib,
  ...
}: let
  enabled = config.scarisey.homelab.enable;
  cfg = config.scarisey.homelab.textfileCollector;
in
  lib.mkIf enabled {
    systemd.tmpfiles.rules = [
      "d ${cfg.path} 0755 prometheus prometheus -"
    ];

    systemd.services.update-manual-metrics = {
      description = "Update Prometheus metrics from manually collected ones.";
      serviceConfig = let
        script = pkgs.writeShellApplication {
          name = "update-manual-metrics";

          runtimeInputs = with pkgs; [
            curl
            coreutils
            git
          ];

          text = ''
            set -eu

            remote_rev=$( ${pkgs.git}/bin/git ls-remote ${cfg.publicFlakeUrl} refs/heads/main | cut -f1 )
            local_rev=$(cat ${cfg.flakeRevisionPath})

            mkdir -p ${cfg.path}
            cat <<EOF > ${cfg.path}/collected.prom
            nixos_flake_local_revision{type="local", revision="$local_rev"} 1
            nixos_flake_remote_revision{type="remote", revision="$remote_rev"} 1
            nixos_flake_revision_match $( [[ "$local_rev" = "$remote_rev" ]] && echo 1 || echo 0 )
            EOF
          '';
        };
      in {
        Type = "oneshot";
        ExecStart = "${script}/bin/update-manual-metrics";
        User = "root";
        Group = "root";
      };
    };

    # --- Run periodically
    systemd.timers.update-textfile-collector = {
      description = "Periodic update of manual metrics";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "2min";
        OnUnitActiveSec = "10min";
        Unit = "update-manual-metrics.service";
      };
    };
  }
