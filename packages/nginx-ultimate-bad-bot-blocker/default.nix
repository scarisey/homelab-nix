{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-ZW+3PHSO879nVXPuqTXHM/IXPaLM47YzD1U/8z49cPQ=";
}
