#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Run the scan

cd website
bundle install
bundle show
bundle exec jekyll build --verbose --destination _site

if ([ $TRAVIS_BRANCH == "master" ] && [ $TRAVIS_PULL_REQUEST == "false" ]); then
  cd _site
  git init
  git remote add origin "$GIT_REMOTE"
  git add .
  git commit -m "Deploy to GitHub Pages"
  git push --force --quiet origin master:gh-pages > /dev/null 2>&1
  echo 'Build successful, deployed to gh-pages.'
else
  echo "Build successful, but not deploying!"
fi
