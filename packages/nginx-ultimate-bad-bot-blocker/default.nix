{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-tnxbSIO8rTU4bX4EDTEDQl9F3L/vj/ma1NeRAz8lOvM=";
}
