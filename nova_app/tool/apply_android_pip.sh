#!/usr/bin/env bash
set -euo pipefail

mkdir -p android/app/src/main/kotlin/com/example/novatube_app
cp android_custom/AndroidManifest.xml android/app/src/main/AndroidManifest.xml
cp android_custom/MainActivity.kt android/app/src/main/kotlin/com/example/novatube_app/MainActivity.kt
