{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-5JJdTfcLtvG4uo7jbp1aBtj1pVqKVOsCsFkXjj9bDPc=";
}
