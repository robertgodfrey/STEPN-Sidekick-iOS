#!/bin/sh

set -e
set -x

cd ..
ls -la
touch STEPN\ Sidekick/secrets.json
printf "{\"APP_LOVIN_SDK_KEY\":\%s\",\"MAIN_AD_ID\":\"%s\"}" "$APP_LOVIN_SDK_KEY", "$MAIN_AD_ID" >> STEPN\ Sidekick/secrets.json
echo "created secrets.json"

cat STEPN\ Sidekick/secrets.json

# install homebrew if not already installed
if ! command -v brew &> /dev/null
then
    echo "Homebrew not found, installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed"
fi

brew update
brew install cocoapods
pod install

