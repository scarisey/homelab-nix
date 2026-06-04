{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-mdHj5aIXS1od/lxDfMs8x/yVq7vZ9nzMfjjKOkHoUTk=";
}
