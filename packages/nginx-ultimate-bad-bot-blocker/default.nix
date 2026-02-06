{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-PiZwVOfyPJZd/5QqkVqztuXKOQQ5YxxZPR1KD2cQPQU=";
}
