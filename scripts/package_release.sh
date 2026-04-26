#!/usr/bin/env bash
set -euo pipefail

APP_NAME="NiceTimer"
VERSION="${1:-0.1.0}"
BUILD_NUMBER="${2:-1}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
APP_DIR="$ROOT_DIR/build/$APP_NAME.app"
ARCHIVE_PATH="$DIST_DIR/$APP_NAME-$VERSION.zip"

mkdir -p "$DIST_DIR"

bash "$ROOT_DIR/scripts/build_app.sh" release "$VERSION" "$BUILD_NUMBER" >/dev/null

rm -f "$ARCHIVE_PATH"
cd "$ROOT_DIR/build"
/usr/bin/ditto -c -k --keepParent "$APP_NAME.app" "$ARCHIVE_PATH"

echo "$ARCHIVE_PATH"
