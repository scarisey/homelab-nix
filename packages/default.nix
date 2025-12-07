{pkgs, ...}: {
  coreruleset = pkgs.callPackage ./coreruleset {};
  nginx_ultimate_bad_bot_blocker = pkgs.callPackage ./nginx-ultimate-bad-bot-blocker {};
}
