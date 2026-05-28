{pkgs, ...}:
pkgs.fetchFromGitHub {
  owner = "mitchellkrogza";
  repo = "nginx-ultimate-bad-bot-blocker";
  rev = "master";
  hash = "sha256-XtARG8Y8nz8W0rxtBXRpunQSnlacLNu1E0B00DE3MGo=";
}
