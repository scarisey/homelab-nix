{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-O94JLqDyRfD7j1IjvxiAbOOh+8ak4AsvOieHKukxFs8=";
}
