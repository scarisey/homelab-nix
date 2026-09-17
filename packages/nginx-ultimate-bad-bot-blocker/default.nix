{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-RfNgyyftRKTe8BOvvPtc6YJ3CxE4l2tx8m0gVI50BqU=";
}
