#!/bin/bash
# Run the scan
./scan.sh

cd website
bundle install
bundle exec jekyll build

if ([ $TRAVIS_BRANCH == "travis" ] && [ $TRAVIS_PULL_REQUEST == "false" ]); then
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
