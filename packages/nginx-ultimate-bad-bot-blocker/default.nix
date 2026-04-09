{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-8pi/guSkzVoxSC0zzl4KYDLHAkZWyEZ3o2BW//INJnw=";
}
