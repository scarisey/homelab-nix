{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-LjSMVQ9mGQc4TgRQh/pZfgaX8ATvC4kNXFH7aTBZM7c=";
}
