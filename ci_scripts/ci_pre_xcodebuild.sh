#!/bin/zsh

script_dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd "$script_dir/.."

echo $FILE_FIREBASE_STAGING | base64 --decode > App/BeMatch/Multiplatform/Staging/GoogleService-Info.plist
echo $FILE_FIREBASE_PRODUCTION | base64 --decode > App/BeMatch/Multiplatform/Production/GoogleService-Info.plist

echo $FILE_FIREBASE_STAGING | base64 --decode > App/TapMatch/Multiplatform/Staging/GoogleService-Info.plist
echo $FILE_FIREBASE_PRODUCTION | base64 --decode > App/TapMatch/Multiplatform/Production/GoogleService-Info.plist

echo $FILE_FIREBASE_STAGING | base64 --decode > App/Trinket/Multiplatform/Staging/GoogleService-Info.plist
echo $FILE_FIREBASE_PRODUCTION | base64 --decode > App/Trinket/Multiplatform/Production/GoogleService-Info.plist

echo $FILE_FIREBASE_STAGING | base64 --decode > App/TenMatch/Multiplatform/Staging/GoogleService-Info.plist
echo $FILE_FIREBASE_PRODUCTION | base64 --decode > App/TenMatch/Multiplatform/Production/GoogleService-Info.plist