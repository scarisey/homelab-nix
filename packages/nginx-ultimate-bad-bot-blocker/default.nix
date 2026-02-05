{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-vX27xjC8hKaomn1u7CrUv+xD0TDcBihxU3T5xpM9oqE=";
}
