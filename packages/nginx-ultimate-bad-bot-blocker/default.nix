{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-enYOcj3ZjRj+Go32ZQit/eZIyKyEVd90KA0PZdUTkYE=";
}
