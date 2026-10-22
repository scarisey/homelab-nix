{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-IC2rgBkfK6Ao3TcHST2xQQVPIb3FONbR+Hrg4TFiEAU=";
}
