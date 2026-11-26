package com.novatube.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import com.novatube.app.feature.home.HomeScreen

private val NovaBlack = Color(0xFF000000)
private val NovaSurface = Color(0xFF101722)
private val NovaBlue = Color(0xFF1677FF)
private val NovaLightBlue = Color(0xFF54B5FF)

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            NovaTheme {
                HomeScreen()
            }
        }
    }
}

@Composable
private fun NovaTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = darkColorScheme(
            primary = NovaBlue,
            secondary = NovaLightBlue,
            background = NovaBlack,
            surface = NovaSurface,
            onPrimary = Color.White,
            onBackground = Color.White,
            onSurface = Color.White
        ),
        content = content
    )
}
