{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-z3kd+1wYqN1RCaFILEWHt/TybE1rHQO6H0wokTmp9Dg=";
}
