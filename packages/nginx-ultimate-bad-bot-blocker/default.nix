{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-FBn74o8b/INIR7LQLIccpvZlaDvt7aTnu4DgyE3Bma8=";
}
