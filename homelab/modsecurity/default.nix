{pkgs, ...}:
pkgs.writeTextFile {
  name = "main.conf";
  text = ''
    Include ${./modsecurity.conf}
    Include ${pkgs.coreruleset}/crs-setup.conf
    Include ${pkgs.coreruleset}/rules/*.conf
  '';
}
