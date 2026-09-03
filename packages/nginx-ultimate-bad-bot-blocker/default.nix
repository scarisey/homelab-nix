{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-uC70DZTL/WiKYsybLLkH33rWzed7gTdIQbqUOjmVbZY=";
}
