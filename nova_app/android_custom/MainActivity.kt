package com.example.novatube_app

import android.app.PictureInPictureParams
import android.content.Intent
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.content.pm.PackageManager
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.novatube.app/picture_in_picture"
    private val backgroundChannelName = "com.novatube.app/background_play"
    private var pipEnabled = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, backgroundChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setMode" -> {
                        val mode = call.argument<String>("mode") ?: "off"
                        if (mode !in setOf("always", "headphones", "off")) {
                            result.error("INVALID_MODE", "Unsupported background mode", null)
                        } else {
                            getSharedPreferences("novatube_playback", MODE_PRIVATE)
                                .edit().putString("background_mode", mode).apply()
                            result.success(true)
                        }
                    }
                    "play" -> {
                        val mode = getSharedPreferences("novatube_playback", MODE_PRIVATE)
                            .getString("background_mode", "off") ?: "off"
                        val uri = call.argument<String>("uri")
                        if (mode == "off") {
                            result.error("BACKGROUND_DISABLED", "Background Play is off", null)
                        } else if (uri.isNullOrBlank()) {
                            result.error("MISSING_MEDIA_URI", "A supported media stream URI is required", null)
                        } else if (mode == "headphones" && !hasExternalAudioOutput()) {
                            result.error("NO_EXTERNAL_AUDIO", "Connect headphones or an external speaker to use this mode", null)
                        } else {
                            val intent = Intent(this, NovaPlaybackService::class.java).apply {
                                action = NovaPlaybackService.ACTION_PLAY
                                putExtra(NovaPlaybackService.EXTRA_URI, uri)
                                putExtra(NovaPlaybackService.EXTRA_TITLE, call.argument<String>("title") ?: "NovaTube")
                                putExtra(NovaPlaybackService.EXTRA_ARTIST, call.argument<String>("artist") ?: "NovaTube")
                            }
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) startForegroundService(intent)
                            else startService(intent)
                            result.success(true)
                        }
                    }
                    "stop" -> {
                        stopService(Intent(this, NovaPlaybackService::class.java))
                        result.success(true)
                    }
                    "getMode" -> result.success(
                        getSharedPreferences("novatube_playback", MODE_PRIVATE)
                            .getString("background_mode", "off") ?: "off"
                    )
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setEnabled" -> {
                        pipEnabled = call.argument<Boolean>("enabled") ?: false
                        result.success(isPipSupported())
                    }
                    "isSupported" -> result.success(isPipSupported())
                    else -> result.notImplemented()
                }
            }
    }

    private fun hasExternalAudioOutput(): Boolean {
        val audioManager = getSystemService(AUDIO_SERVICE) as AudioManager
        return audioManager.getDevices(AudioManager.GET_DEVICES_OUTPUTS).any { device ->
            device.type == AudioDeviceInfo.TYPE_WIRED_HEADPHONES ||
                device.type == AudioDeviceInfo.TYPE_WIRED_HEADSET ||
                device.type == AudioDeviceInfo.TYPE_USB_HEADSET ||
                device.type == AudioDeviceInfo.TYPE_BLUETOOTH_A2DP ||
                device.type == AudioDeviceInfo.TYPE_BLE_HEADSET ||
                device.type == AudioDeviceInfo.TYPE_BLE_SPEAKER
        }
    }

    private fun isPipSupported(): Boolean =
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
            packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)

    override fun onUserLeaveHint() {
        if (pipEnabled && isPipSupported() && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val params = PictureInPictureParams.Builder()
                .setAspectRatio(Rational(16, 9))
                .build()
            enterPictureInPictureMode(params)
        }
        super.onUserLeaveHint()
    }
}
