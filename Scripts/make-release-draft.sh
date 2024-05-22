#!/bin/bash

# 事前にghコマンドのinstall及び設定が必要
# https://docs.github.com/ja/github-cli/github-cli/quickstart

# option解析
SERVICE=''
IS_PATCH=
while getopts pn: OPT
do
  case $OPT in
    "p" ) IS_PATCH=1 ;;
    "n" ) SERVICE=${OPTARG};;
  esac
done

# localのタグを最新にする
echo 'getting latest tag...'

# fetch tags in advance
git fetch --tags -f

LATEST_TAG=`git tag -l "${SERVICE}/*" --sort=-v:refname | head -n1`
echo "latest tag: $LATEST_TAG"

NEXT_TAG=`echo $LATEST_TAG | awk -F. -v 'OFS=.' '{print $1,$2+1,0}'`
if [ ! -z "$IS_PATCH" ]; then
  NEXT_TAG=`echo $LATEST_TAG | awk -F. -v 'OFS=.' '{print $1,$2,$3+1}'`
fi
echo "next tag: $NEXT_TAG"

read -p "ok? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "canceled." ; exit ;; esac

DRAFT_URL=$(gh release create $NEXT_TAG\
  --generate-notes \
  --draft \
  --latest \
  --notes-start-tag $LATEST_TAG \
  --target main)

echo $DRAFT_URL
open $DRAFT_URL