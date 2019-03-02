#!/bin/bash

wget "https://data.iana.org/TLD/tlds-alpha-by-domain.txt" --output-document tlds.txt

(for domain in $(grep -v '^#' tlds.txt); do 
	host -W 1 -t A "${domain}."
done) | grep -v 'has no A record'