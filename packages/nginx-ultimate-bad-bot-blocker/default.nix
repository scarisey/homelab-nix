{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-nENSzyUvFbbQdRwunHLwGHrlCq8+6c2lS/yzZnnIPRY=";
}
