{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-2tkbmYNxptyu57wnSehuADcqdaNE/26HyiWV4CErJbs=";
}
