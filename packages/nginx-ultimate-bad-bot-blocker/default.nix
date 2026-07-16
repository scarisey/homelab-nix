{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-zfVfCoJ2fkxVHNf+cHZ6CGCs1VEf/9Jhh4z/osW05Ws=";
}
