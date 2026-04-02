{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-3nOf7zmC7EF3cCEF+viCTM81DEBh0Wx+3m2g8+T516o=";
}
