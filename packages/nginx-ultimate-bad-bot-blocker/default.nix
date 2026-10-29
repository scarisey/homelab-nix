{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-+k+v5+wWxlldImZ2L08HSobPeHggQDw1ew/kTA2UPkI=";
}
