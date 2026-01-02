{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-Dsq2jRjcGDIvIV4w9LcyeeaaNN/vl0jLeshrsBqCalg=";
}
