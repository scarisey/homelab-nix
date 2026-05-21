{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-7AYSDopgz3SENA6xRsEX35GeDKwXK3//Ni1tKNQI6Y8=";
}
