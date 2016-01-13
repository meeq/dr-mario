#!/bin/sh
# Flamingo QuickStart script
set -euf -o pipefail

echo "Installing Ruby gems..."
bundle install

echo "Installing Node packages..."
npm install -g grunt-cli
npm install .

echo "Flamingo is all set up!"
echo 'Run `grunt develop` to start the development server.'
