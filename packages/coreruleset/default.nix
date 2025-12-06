{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  version = "4.21.0";
  pname = "coreruleset";

  src = fetchFromGitHub {
    owner = "coreruleset";
    repo = "coreruleset";
    rev = "v${version}";
    sha256 = "sha256-mItipTFsRug0y7dyRCkWcqaWDcDetT35SiSKG/RDsII=";
  };

  installPhase = ''
    mkdir $out
    resultingConf=$(mktemp)
    cp $src/crs-setup.conf.example $resultingConf
    echo "" >> $resultingConf
    echo "# -- [[ Additional configuration ]] --------------------------------------------------------" >> $resultingConf
    echo "" >> $resultingConf
    cat ${./additional.conf} >> $resultingConf
    cp $resultingConf $out/crs-setup.conf
    cp -R $src/rules $out/
    cp -R $src/*.md $out/
    cp -R $src/*.example $out/
  '';

  meta = with lib; {
    homepage = "https://coreruleset.org";
    description = ''
      The OWASP ModSecurity Core Rule Set is a set of generic attack detection
      rules for use with ModSecurity or compatible web application firewalls.
    '';
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
