{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-FjRLPHZuapMTYGlIOK+JK7Kday0jeeh883Z8KQl3oVU=";
}
