#!/bin/bash
# we need dig
sudo apt install dnsutils
# Run the scan
./scan.sh

cd website
bundle install
bundle exec jekyll build