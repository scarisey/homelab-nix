{config, ...}: let
  cfg = config.scarisey.homelab;
in {
  services.fail2ban = {
    enable = true;
    maxretry = 3;
    ignoreIP = [
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
    ];
    bantime = "24h";
    bantime-increment = {
      enable = true;
      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
    jails = {
      "nginx-bad-request".settings = {
        enabled = true;
        backend = "auto";
        logpath = "/var/log/nginx/access.log";
      };
      "nginx-botsearch".settings = {
        enabled = true;
        backend = "auto";
        logpath = "/var/log/nginx/access.log";
      };
      "nginx-forbidden".settings = {
        enabled = true;
        backend = "auto";
        logpath = "/var/log/nginx/access.log";
      };
      "nginx-http-auth".settings = {
        enabled = true;
        backend = "auto";
        logpath = "/var/log/nginx/access.log";
      };
    };
  };
}
