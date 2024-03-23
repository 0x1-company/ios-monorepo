#!/bin/sh
set -e

if [[ $CI_WORKFLOW != "Upload Symbols" ]];
then
    echo "CI_WORKFLOWがUpload Symbols以外のため、dSYMアップロードを実行しません"
    exit 0
fi

if [[ -z $CI_ARCHIVE_PATH ]];
then
    echo "CI_ARCHIVE_PATHが存在しないため、dSYMアップロードを実行しません"
    exit 0
fi

# ここに新しいコードを追加する
# 親ディレクトリに移動
cd ..
# Crashlytics dSYMs スクリプトを実行
$CI_DERIVED_DATA_PATH/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols -gsp $CI_PRIMARY_REPOSITORY_PATH/App/BeMatch/Multiplatform/Production/GoogleService-Info.plist -p ios $CI_ARCHIVE_PATH/dSYMs
