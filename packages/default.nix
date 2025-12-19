{pkgs, ...}: {
  coreruleset = pkgs.callPackage ./coreruleset {};
  nginx-ultimate-bad-bot-blocker = pkgs.callPackage ./nginx-ultimate-bad-bot-blocker {};
}
