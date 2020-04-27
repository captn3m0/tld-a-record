#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
BRANCH="gh-pages"
# Run the scan

cd website
bundle install
bundle show
bundle exec jekyll build --verbose --destination _site

git clone "$GIT_REMOTE" --branch "$BRANCH" /tmp/remote_site

if ([ $TRAVIS_BRANCH == "master" ] && [ $TRAVIS_PULL_REQUEST == "false" ]); then
  cp -r _site/* /tmp/remote_site
  cd /tmp/remote_site
  git add .
  git commit -m "Update: `date`"
  git push --force --quiet origin > /dev/null 2>&1
  echo 'Build successful, deployed to gh-pages.'
else
  echo "Build successful, but not deploying!"
fi
