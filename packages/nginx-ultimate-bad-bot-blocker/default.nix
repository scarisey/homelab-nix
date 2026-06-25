{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-0dHkQXHySR2wUUk0EqorrhcBws3pbXI1fDtsbhmlP8M=";
}
