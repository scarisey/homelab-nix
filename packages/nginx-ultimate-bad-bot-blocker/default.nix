{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-3gIiiKcGB0UAnhcmnc4i8SNSVj2lwyard0kDT/McIdk=";
}
