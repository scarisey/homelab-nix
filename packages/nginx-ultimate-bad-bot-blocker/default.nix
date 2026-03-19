{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-OOMqLz1tIU8dV6T+5E3o5bs4a8PzQUcwYRyWbp9HtHI=";
}
