{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-fU3Qh6iiLfN09bKrn6WSi5c7Gq8TOiAXgVuRx1cwYUo=";
}
