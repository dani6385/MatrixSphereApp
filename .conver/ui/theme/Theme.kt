package com.example.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable

private val DarkColorScheme = darkColorScheme(
    primary = CyanPrimary,
    secondary = BlueSecondary,
    tertiary = TealTertiary,
    background = SlateBackgroundDark,
    surface = SlateSurfaceDark,
    onPrimary = SlateBackgroundDark,
    onSecondary = SlateBackgroundDark,
    onTertiary = SlateBackgroundDark,
    onBackground = TextOnDarkPrimary,
    onSurface = TextOnDarkPrimary,
    surfaceVariant = SlateBorderDark,
    onSurfaceVariant = TextOnDarkSecondary
)

private val LightColorScheme = lightColorScheme(
    primary = BlueSecondary,
    secondary = CyanPrimary,
    tertiary = TealTertiary,
    background = SlateBackgroundLight,
    surface = SlateSurfaceLight,
    onPrimary = SlateSurfaceLight,
    onSecondary = SlateSurfaceLight,
    onTertiary = SlateSurfaceLight,
    onBackground = TextOnLightPrimary,
    onSurface = TextOnLightPrimary,
    surfaceVariant = SlateBorderLight,
    onSurfaceVariant = TextOnLightSecondary
)

@Composable
fun MyApplicationTheme(
    darkTheme: Boolean = true,
    content: @Composable () -> Unit
) {
    val colorScheme = DarkColorScheme

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}
