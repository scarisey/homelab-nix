{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-JQnm1OXVhWQNyfg7VUbeMq1bJijPRZnoYJmEqTuDvn4=";
}
