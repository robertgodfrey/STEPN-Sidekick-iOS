#!/bin/sh

set -e
set -x

cd ..

printf "APP_LOVIN_SDK_KEY = %s\nMAIN_AD_ID = %s" "$APP_LOVIN_SDK_KEY" "$MAIN_AD_ID" >> Environment.xcconfig

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

