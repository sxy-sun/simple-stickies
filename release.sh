#!/bin/bash
# Builds the app and packages dist/SimpleStickies.zip for the Homebrew cask.
set -e
cd "$(dirname "$0")"

./build.sh

rm -rf dist && mkdir -p dist
ditto -c -k --keepParent "build/Simple Stickies.app" dist/SimpleStickies.zip

echo
echo "sha256: $(shasum -a 256 dist/SimpleStickies.zip | cut -d' ' -f1)"
ls -lh dist/
