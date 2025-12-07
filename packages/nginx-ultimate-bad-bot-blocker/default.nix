{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-SncDqGQvFbjyF7EjM2OTRZzcoLaCoHBLeosft5TDFJc=";
}
