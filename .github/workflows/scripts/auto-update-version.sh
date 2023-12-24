#!/bin/bash

NEW_VERSION=$(date '+%y').$(date '+%m').$(date '+%d')
CURRENT_VERSION=$(defaults read $(pwd)/App/Multiplatform/Info CFBundleShortVersionString)

sed -i '' "s/$CURRENT_VERSION/$NEW_VERSION/g" App/Multiplatform/Info.plist
