{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-K0dg+scfwHl7cMGn1nXtZH9X8Zj72i56rzyeqbfU5oU=";
}
