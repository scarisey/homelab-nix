{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-SH8t4660/IQKHyRD71ATDM+/Q32wyyLXlREVptJD6Uc=";
}
