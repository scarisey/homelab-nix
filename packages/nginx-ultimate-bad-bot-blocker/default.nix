{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-Kwv30SRxq1EOyPUXtr5PZ5tYcRu8qsPocZ25OiK7YfI=";
}
