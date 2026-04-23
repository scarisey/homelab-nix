{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-RTIgN55aEEZngqs2X0red7lvBM3cEyxPBK5yLrs7Uu8=";
}
