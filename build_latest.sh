#!/usr/bin/env bash
# Push HTML files to gh-pages automatically.

# Fill this out with the correct org/repo
ORG=Art4
REPO=documentation

set -e

# Clone the master branch outside of the repo and cd into it.
cd ..
git clone -b master "https://$GH_TOKEN@github.com/$ORG/$REPO.git" master-branch
cd master-branch

# Update git configuration so I can push.
if [ "$1" != "dry" ]; then
    # Update git config.
    git config user.name "Deployment Bot"
    git config user.email "deploy@travis-ci.org"
fi

echo "removing latest folder"
rm -r docs/latest/

echo "copy new files to latest folder"
# Copy in the HTML.  You may want to change this with your documentation path.
cp -r ../$REPO/_build/html/ ./docs/latest

# Add and commit changes.
echo "create commit"
git add -A .
git commit -m "[ci skip] Build latest version from $TRAVIS_COMMIT."
if [ "$1" != "dry" ]; then
    echo "push to Github repo"
    # -q is very important, otherwise you leak your GH_TOKEN
    git push -q origin master
fi
