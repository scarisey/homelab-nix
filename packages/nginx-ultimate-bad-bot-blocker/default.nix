{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-gyP4JCk3JwgeBCO/H7EVdj7lEHG9hJHuBYxkSNYDvqw=";
}
