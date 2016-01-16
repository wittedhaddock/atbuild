#!/bin/bash
set -e

PLATFORM=macosx
SWIFT_BUILD_TOOL=`which swift-build-tool`

if [ -n "$1" ]; then
  PLATFORM=$1
fi

if [ -z "$SWIFT_BUILD_TOOL" ]; then
  echo "The build tool 'swift-build-tool' cannot be found."
  exit 1
fi


$SWIFT_BUILD_TOOL -f bootstrap/bootstrap-$PLATFORM-atpkg.swift-build --no-db
$SWIFT_BUILD_TOOL -f bootstrap/bootstrap-$PLATFORM-attools.swift-build --no-db
$SWIFT_BUILD_TOOL -f bootstrap/bootstrap-$PLATFORM.swift-build --no-db

if [ "0" = "$?" ]; then
  rm -rf bin
  mkdir -p bin
  ln -s $BUILD_DIR/.atllbuild/products/atbuild bin/atbuild
fi