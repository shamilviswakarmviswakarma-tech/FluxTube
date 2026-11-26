package com.example.novatube_app

import android.content.Intent
import androidx.media3.common.MediaItem
import androidx.media3.common.MediaMetadata
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.session.MediaSession
import androidx.media3.session.MediaSessionService

class NovaPlaybackService : MediaSessionService() {
    private var player: ExoPlayer? = null
    private var mediaSession: MediaSession? = null

    override fun onCreate() {
        super.onCreate()
        val exoPlayer = ExoPlayer.Builder(this).build()
        player = exoPlayer
        mediaSession = MediaSession.Builder(this, exoPlayer).build()
    }

    override fun onGetSession(controllerInfo: MediaSession.ControllerInfo): MediaSession? =
        mediaSession

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_PLAY) {
            val uri = intent.getStringExtra(EXTRA_URI)
            if (!uri.isNullOrBlank()) {
                val metadata = MediaMetadata.Builder()
                    .setTitle(intent.getStringExtra(EXTRA_TITLE) ?: "NovaTube")
                    .setArtist(intent.getStringExtra(EXTRA_ARTIST) ?: "NovaTube")
                    .build()
                player?.setMediaItem(
                    MediaItem.Builder().setUri(uri).setMediaMetadata(metadata).build()
                )
                player?.prepare()
                player?.play()
            }
        }
        return super.onStartCommand(intent, flags, startId)
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        // Keep audio playback alive when the app task is dismissed.
        if (player?.isPlaying != true) stopSelf()
    }

    override fun onDestroy() {
        mediaSession?.release()
        mediaSession = null
        player?.release()
        player = null
        super.onDestroy()
    }

    companion object {
        const val ACTION_PLAY = "com.novatube.app.action.PLAY"
        const val EXTRA_URI = "com.novatube.app.extra.URI"
        const val EXTRA_TITLE = "com.novatube.app.extra.TITLE"
        const val EXTRA_ARTIST = "com.novatube.app.extra.ARTIST"
    }
}
