#!/usr/bin/env bash
set -euo pipefail

APP_NAME="NiceTimer"
VERSION="${1:-0.1.0}"
BUILD_NUMBER="${2:-1}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
APP_DIR="$ROOT_DIR/build/$APP_NAME.app"
ZIP_PATH="$DIST_DIR/$APP_NAME-$VERSION.zip"
DMG_STAGE_DIR="$DIST_DIR/$APP_NAME-$VERSION"
DMG_PATH="$DIST_DIR/$APP_NAME-$VERSION.dmg"

mkdir -p "$DIST_DIR"

bash "$ROOT_DIR/scripts/build_app.sh" release "$VERSION" "$BUILD_NUMBER" >/dev/null

rm -f "$ZIP_PATH" "$DMG_PATH"
rm -rf "$DMG_STAGE_DIR"

cd "$ROOT_DIR/build"
/usr/bin/ditto -c -k --keepParent "$APP_NAME.app" "$ZIP_PATH"

mkdir -p "$DMG_STAGE_DIR"
cp -R "$APP_DIR" "$DMG_STAGE_DIR/$APP_NAME.app"

hdiutil create \
  -volname "$APP_NAME $VERSION" \
  -srcfolder "$DMG_STAGE_DIR" \
  -ov \
  -format UDZO \
  "$DMG_PATH" >/dev/null

rm -rf "$DMG_STAGE_DIR"

echo "$ZIP_PATH"
echo "$DMG_PATH"
