#!/usr/bin/env bash
# Push HTML files to gh-pages automatically.

# Fill this out with the correct org/repo
ORG=Art4
REPO=documentation
# This probably should match an email for one of your users.
EMAIL=art4@wlabs.de

set -e

# Clone the gh-pages branch outside of the repo and cd into it.
cd ..
git clone -b master "https://$GH_TOKEN@github.com/$ORG/$REPO.git" master-branch
cd master-branch

# Update git configuration so I can push.
if [ "$1" != "dry" ]; then
    # Update git config.
    git config user.name "Travis Builder"
    git config user.email "$EMAIL"
fi

rm -r docs/current/
# Copy in the HTML.  You may want to change this with your documentation path.
cp -r ../$REPO/_build/html/ ./docs/current

# Add and commit changes.
git add -A .
git commit -m "[ci skip] Build current version from $COMMIT."
if [ "$1" != "dry" ]; then
    # -q is very important, otherwise you leak your GH_TOKEN
    git push -q origin master
fi
