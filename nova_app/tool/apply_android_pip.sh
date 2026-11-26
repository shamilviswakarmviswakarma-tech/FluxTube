#!/usr/bin/env bash
set -euo pipefail

mkdir -p android/app/src/main/kotlin/com/example/novatube_app
cp android_custom/AndroidManifest.xml android/app/src/main/AndroidManifest.xml
cp android_custom/MainActivity.kt android/app/src/main/kotlin/com/example/novatube_app/MainActivity.kt

# Install the AndroidX Media3 playback service dependencies and native service.
mkdir -p android/app/src/main/kotlin/com/example/novatube_app
cp android_custom/NovaPlaybackService.kt android/app/src/main/kotlin/com/example/novatube_app/NovaPlaybackService.kt
cat >> android/app/build.gradle.kts <<'GRADLE'

dependencies {
    implementation("androidx.media3:media3-exoplayer:1.5.1")
    implementation("androidx.media3:media3-session:1.5.1")
}
GRADLE
