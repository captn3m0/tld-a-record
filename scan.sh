#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

wget --quiet "https://data.iana.org/TLD/tlds-alpha-by-domain.txt" --output-document tlds.txt

for domain in $(grep -v '^#' tlds.txt); do 
    RESULT=$(dig +time=1 +tries=1 +short "$domain" | head -c -1 | tr '\n' '@' | sed 's/@/`,`/g' | grep -v "connection timed out")
    if [ ! -z "$RESULT" ]; then
        echo $domain
        DOMAIN_REAL="$domain"
        # Very crude regex for punycode domains
        if [[ $(echo "$domain" | grep -E  "^XN--[[:upper:]]+$") ]]; then
            DOMAIN_REAL=$(idn --idna-to-unicode "$domain")
        fi
        echo "|$DOMAIN_REAL|$domain|[http](http://$domain)|[https](https://$domain)|\`$RESULT\`|" >> template.md
    fi
done

curl  --silent  'https://ipapi.co/yaml/' > website/_data/ip.json

echo "This scan was last run on $(date)" >> template.md

cp tlds.txt template.md website/