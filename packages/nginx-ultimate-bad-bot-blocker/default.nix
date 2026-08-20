{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-5gLz45FLcGGAVRjKGGTZtGKlS/M61e96NjTZA5XnZwM=";
}
