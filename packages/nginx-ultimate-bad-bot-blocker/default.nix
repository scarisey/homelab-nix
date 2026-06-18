{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-W5Dj1tNZx0n4xQaDLIgyjAs5panCakayXn29+PjtxnA=";
}
