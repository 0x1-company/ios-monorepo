#!/bin/sh
set -e
if [[ -n $CI_ARCHIVE_PATH ]];
then
    # 親ディレクトリに移動
    cd ..
    # Crashlytics dSYMs スクリプトを実行
    $CI_DERIVED_DATA_PATH/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols -gsp $CI_PRIMARY_REPOSITORY_PATH/App/BeMatch/Multiplatform/Production/GoogleService-Info.plist -p ios $CI_ARCHIVE_PATH/dSYMs
else
    echo "アーカイブパスが使用できないため、dSYMアップロードを実行できません"
fi
