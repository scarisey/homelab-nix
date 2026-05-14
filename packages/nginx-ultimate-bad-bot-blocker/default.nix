{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-phrXCC5FiPclu1u3JmSnU7nROBDg58jmYAUvN8p//eM=";
}
