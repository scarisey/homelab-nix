{
  fetchurl,
  jq,
}:
fetchurl {
  url = "https://api.cloudflare.com/client/v4/ips";

  nativeBuildInputs = [ jq ];

  downloadToTemp = true;
  postFetch = ''
    cat $downloadedFile | jq -r '.result.ipv4_cidrs |"allow " + .[]' >> $out
    cat $downloadedFile | jq -r '.result.ipv6_cidrs |"allow " + .[]' >> $out
  '';

  hash = "sha256-33DydY5oLgVhdQiezOgQ81bkLFqvGVDZ3hjG+Kz94sk=";
}

