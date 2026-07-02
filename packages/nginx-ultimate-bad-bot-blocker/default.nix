{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-K1RqRh+vuVX+IORKoYALH/bw8OK4YhPRfcDucfWjh7Q=";
}
