#!/bin/bash
# Run the scan
./scan.sh

cd website
bundle install
bundle exec jekyll build