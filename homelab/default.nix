args @ {
  config,
  lib,
  pkgs,
  ...
}: let
  allConfig = {
    imports = [
      ./libProxy.nix
      ./blocky.nix
      ./fail2ban.nix
      ./proxy.nix
      ./postgresql.nix
      ./monitoring/loki.nix
      ./monitoring/prometheus.nix
      ./monitoring/grafana.nix
      ./monitoring/alloy.nix
      ./autoProxy.nix
    ];
    options = import ./options.nix args;
  };
in
  allConfig
