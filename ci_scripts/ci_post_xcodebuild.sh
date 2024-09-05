#!/bin/sh
set -e

if [[ -z $CI_ARCHIVE_PATH ]]; then
    echo "CI_ARCHIVE_PATHが存在しないため、dSYMアップロードを実行しません"
    exit 0
fi

if [[ $CI_BUNDLE_ID == *"staging"* ]]; then
    TARGET_ENV="Staging"
else
    TARGET_ENV="Production"
fi

# 親ディレクトリに移動
cd ..

# Crashlytics dSYMs スクリプトを実行
$CI_DERIVED_DATA_PATH/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols -gsp $CI_PRIMARY_REPOSITORY_PATH/App/BeMatch/Multiplatform/$TARGET_ENV/GoogleService-Info.plist -p ios $CI_ARCHIVE_PATH/dSYMs
$CI_DERIVED_DATA_PATH/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols -gsp $CI_PRIMARY_REPOSITORY_PATH/App/PicMatch/Multiplatform/$TARGET_ENV/GoogleService-Info.plist -p ios $CI_ARCHIVE_PATH/dSYMs
$CI_DERIVED_DATA_PATH/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols -gsp $CI_PRIMARY_REPOSITORY_PATH/App/TapMatch/Multiplatform/$TARGET_ENV/GoogleService-Info.plist -p ios $CI_ARCHIVE_PATH/dSYMs
$CI_DERIVED_DATA_PATH/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols -gsp $CI_PRIMARY_REPOSITORY_PATH/App/Trinket/Multiplatform/$TARGET_ENV/GoogleService-Info.plist -p ios $CI_ARCHIVE_PATH/dSYMs
$CI_DERIVED_DATA_PATH/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols -gsp $CI_PRIMARY_REPOSITORY_PATH/App/TenMatch/Multiplatform/$TARGET_ENV/GoogleService-Info.plist -p ios $CI_ARCHIVE_PATH/dSYMs
