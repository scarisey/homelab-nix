{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-WzzWcUT7iCZ1R1cLCVugREib2l5Nbllt2eJA9+TAJog=";
}
