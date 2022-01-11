#!/bin/bash

# This script runs a scan for all available TLDs, and notes
# down the TLDs that resolve to `website/template.md`
#
# It also puts some information about the IP Adress from where
# the scan was run (might be relevant for DNS lookups) into
# `website/_data/ip.json`. Structure is at ipapi.co

# A complete text of each TLD is kept inside "tld/$domain.txt"

wget "https://data.iana.org/TLD/tlds-alpha-by-domain.txt" --output-document website/tlds.txt
wget 'https://ipapi.co/yaml/' --output-document website/_data/ip.json
wget https://www.internic.net/domain/root.zone --output-document website/root.zone.txt
mkdir tld whois

for domain in $(grep -v '^#' website/tlds.txt); do
    DOMAIN_REAL="$domain"
    # Very crude regex for punycode domains
    if [[ $(echo "$domain" | grep -E  "^XN--[[:upper:]]+$") ]]; then
        DOMAIN_REAL=$(idn --idna-to-unicode "$domain")
    fi
    python script.py "$domain." | sort > "tld/$domain.txt"
    whois "$domain." > "whois/$domain.txt"
    echo "$DOMAIN_REAL|$domain|[whois](whois/$domain.txt)|[dns](tld/$domain.txt)" >> template.md
done

echo "This scan was last run on $(date)" >> footer.md
cat index.md footer.md > website/index.md
cp -r whois tld website/