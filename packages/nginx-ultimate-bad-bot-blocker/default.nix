{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-Z7p9HU5ksTCtMsBbWuAL17AQmYluwve+Msnnta/rDZM=";
}
