{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-8zPutPC7hbdpiYdrMjmteawuZX0P49qfCFkwqNYSL/Q=";
}
