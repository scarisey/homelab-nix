{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-oVzaOzzKKvLYW9xg6NYsx19dwzfkZSO9x0MctQhcdqA=";
}
