{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-37rf7mKaFMPnue6zyn+RwfJXMpVdbPqfQ1tXZ/5MpR0=";
}
