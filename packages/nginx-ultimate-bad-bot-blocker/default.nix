{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-dqK9SMwbPVRKrhk/NrMkSmz6gBbGlCtEDzQ1/0HEfww=";
}
