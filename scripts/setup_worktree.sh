#!/usr/bin/env bash
# Expected to be executed from directly under worktree
# ────────────────────────────────────────────────
set -euo pipefail

SRC_DIR="../../onepage"      # Relative path to the original repository
DST_DIR="."                  # (= current worktree root)

files=(
    "packages/app/dart_defines/dev.env"
    "packages/app/dart_defines/prod.env"
    "packages/app/lib/environment/src/firebase_options_dev.dart"
    "packages/app/lib/environment/src/firebase_options_prod.dart"
    "packages/app/android/app/src/dev/google-services.json"
    "packages/app/android/app/src/prod/google-services.json"
    "packages/app/ios/dev/GoogleService-Info.plist"
    "packages/app/ios/prod/GoogleService-Info.plist"
    "packages/app/ios/dev/firebase_app_id_file.json"
    "packages/app/ios/prod/firebase_app_id_file.json"
)

for f in "${files[@]}"; do
    install -Dm644 "${SRC_DIR}/${f}" "${DST_DIR}/${f}"
done
