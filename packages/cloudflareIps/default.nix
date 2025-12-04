{
  fetchurl,
  jq,
}: fetchurl {
    url = "https://api.cloudflare.com/client/v4/ips";

    nativeBuildInputs = [jq];

    downloadToTemp = true;
    postFetch = ''
      cat $downloadedFile | jq '.result.ipv4_cidrs + .result.ipv6_cidrs' > $out
    '';

    hash = "sha256-FxtZpXPb34kDUXhoX52izWvR2Dl2rZ4xJJQMDGwPRls=";
  }
