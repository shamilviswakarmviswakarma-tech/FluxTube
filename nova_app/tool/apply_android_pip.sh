#!/usr/bin/env bash
set -euo pipefail

PACKAGE_DIR="android/app/src/main/kotlin/com/example/novatube_app"
GRADLE_FILE="android/app/build.gradle.kts"

mkdir -p "$PACKAGE_DIR"
cp android_custom/AndroidManifest.xml android/app/src/main/AndroidManifest.xml
cp android_custom/MainActivity.kt "$PACKAGE_DIR/MainActivity.kt"
cp android_custom/NovaPlaybackService.kt "$PACKAGE_DIR/NovaPlaybackService.kt"

# Keep this script safe to rerun: add Media3 dependencies only once.
if ! grep -q 'androidx.media3:media3-exoplayer' "$GRADLE_FILE"; then
  cat >> "$GRADLE_FILE" <<'GRADLE'

dependencies {
    implementation("androidx.media3:media3-exoplayer:1.5.1")
    implementation("androidx.media3:media3-session:1.5.1")
}
GRADLE
fi
