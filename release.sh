#!/bin/bash
# Builds the app, packages dist/SimpleStickies.zip, and points the Homebrew
# cask at it. Zips are not reproducible, so the checksum changes on every
# build; updating the cask here keeps the two from drifting apart.
set -e
cd "$(dirname "$0")"

./build.sh

rm -rf dist && mkdir -p dist
ditto -c -k --keepParent "build/Simple Stickies.app" dist/SimpleStickies.zip

SHA=$(shasum -a 256 dist/SimpleStickies.zip | cut -d' ' -f1)
sed -i '' "s|sha256 \".*\"|sha256 \"$SHA\"|" Casks/simple-stickies.rb

VERSION=$(awk -F'"' '/^  version/ {print $2}' Casks/simple-stickies.rb)

cat <<EOF

Built dist/SimpleStickies.zip ($(du -h dist/SimpleStickies.zip | cut -f1))
Cask updated to sha256 $SHA

Next:
  git add Casks/simple-stickies.rb && git commit -m "Release v$VERSION" && git push
  gh release create v$VERSION dist/SimpleStickies.zip --title "Simple Stickies $VERSION"

Upload this exact zip. Rebuilding changes the checksum and breaks the cask.
EOF
