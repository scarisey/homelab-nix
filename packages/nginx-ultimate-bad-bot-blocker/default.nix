{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-aYcoEASFRkuWCvgkKf/WwYeEq6ahEVgZ94JS9fM9C88=";
}
