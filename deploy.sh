#!/bin/bash

set -o errexit

theme=$1
if [ -z "$theme" ]; then
    theme="elegant" # This will be the default theme if no theme is specified.
fi

# Generate the resume as index.html
resume export index --format html --theme "${theme}"

# Copy output file and check for changes
if [ -z "$(git status --porcelain)" ]; then
    echo "No changes to resume. Skipping deployment..."
    exit 0
fi

rm -rf out
mkdir out
cd out
cp ../index.html .

# Deploy
git config --global user.name "Ben Gadbois"
git config --global user.email "enharmonicdistortion@gmail.com"
git init
git add index.html
git commit -m "Publish resume via Travis CI build $TRAVIS_COMMIT"
git push --force --quiet "https://${GITHUB_TOKEN}@${GH_REF}" master:gh-pages

echo "Resume published successfully"
exit 0
