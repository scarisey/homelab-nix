{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-EwJeyoj+oq9DAFsY5rKh27RxCizkG8rAxh+lRdpasOc=";
}
