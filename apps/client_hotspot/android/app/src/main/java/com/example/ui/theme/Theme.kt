package com.example.ui.theme

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext

private val SleekColorScheme =
  lightColorScheme(
    primary = SleekIndigo,
    secondary = SleekBlue,
    tertiary = AmberOrange,
    background = SleekBackground,
    surface = SleekSurface,
    onPrimary = SleekSurface,
    onSecondary = SleekTextPrimary,
    onBackground = SleekTextPrimary,
    onSurface = SleekTextPrimary,
    error = RedWarning
  )

@Composable
fun MyApplicationTheme(
  darkTheme: Boolean = false, // Default to light Sleek Theme
  dynamicColor: Boolean = false, // Disable dynamic colors to preserve our brand palette
  content: @Composable () -> Unit,
) {
  // Always enforce our custom SleekColorScheme to match design theme mockup
  MaterialTheme(
    colorScheme = SleekColorScheme,
    typography = Typography,
    content = content
  )
}
