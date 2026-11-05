{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-zlJhQkU4A0yd2QeWJsFU9AnYJdsXKIV423+c7oZg7rQ=";
}
