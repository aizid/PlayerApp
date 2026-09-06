#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE="${PROJECT_DIR}/PlayerApp"
PROJECT="${WORKSPACE}/PlayerApp.xcodeproj"
SCHEME="PlayerApp"
ARCHIVE_PATH="${PROJECT_DIR}/build/PlayerApp.xcarchive"
EXPORT_PATH="${PROJECT_DIR}/build/export"
EXPORT_OPTIONS="${PROJECT_DIR}/ExportOptions.plist"
FIREBASE_APP_ID="1:352387897762:ios:165a889b6b9350de603afb"

RELEASE_NOTES="${1:-"New build deployed on $(date '+%Y-%m-%d %H:%M:%S')"}"
TESTER_GROUPS="${2:-"testers"}"

echo "=========================================="
echo "🚀 Building & Distributing to Firebase"
echo "=========================================="
echo "Scheme: ${SCHEME}"
echo "Release Notes: ${RELEASE_NOTES}"
echo "Tester Groups: ${TESTER_GROUPS}"

mkdir -p "${PROJECT_DIR}/build"
rm -rf "${ARCHIVE_PATH}" "${EXPORT_PATH}"

echo ""
echo "🧪 Running Unit Tests..."
xcodebuild test \
  -project "${PROJECT}" \
  -scheme "${SCHEME}" \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -parallel-testing-enabled NO \
  -only-testing:PlayerAppTests

echo ""
echo "🔨 Step 1: Archiving..."
xcodebuild archive \
  -project "${PROJECT}" \
  -scheme "${SCHEME}" \
  -destination "generic/platform=iOS" \
  -archivePath "${ARCHIVE_PATH}"

echo ""
echo "📦 Step 2: Exporting IPA..."
xcodebuild -exportArchive \
  -archivePath "${ARCHIVE_PATH}" \
  -exportPath "${EXPORT_PATH}" \
  -exportOptionsPlist "${EXPORT_OPTIONS}"

IPA_PATH="${EXPORT_PATH}/PlayerApp.ipa"

if [ ! -f "${IPA_PATH}" ]; then
  echo "❌ Error: IPA file not found at ${IPA_PATH}"
  exit 1
fi

echo ""
echo "🔥 Step 3: Distributing to Firebase App Distribution..."
firebase appdistribution:distribute "${IPA_PATH}" \
  --app "${FIREBASE_APP_ID}" \
  --release-notes "${RELEASE_NOTES}" \
  --groups "${TESTER_GROUPS}"

echo ""
echo "✅ Success! Release distributed to Firebase."
