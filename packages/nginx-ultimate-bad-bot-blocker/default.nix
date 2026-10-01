{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-DxBG+42LgrU/6pCmJaPDmDc6vuZUbk93s20KgpMMnQQ=";
}
