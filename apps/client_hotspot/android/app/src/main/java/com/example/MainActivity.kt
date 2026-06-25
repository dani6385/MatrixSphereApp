package com.example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.LocalActivity
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.Speed
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.ui.AppScreen
import com.example.ui.HotspotViewModel
import com.example.ui.screens.AccountScreen
import com.example.ui.screens.HomeScreen
import com.example.ui.screens.HotspotWarningBanner
import com.example.ui.screens.LoginScreen
import com.example.ui.screens.SettingsScreen
import com.example.ui.screens.StatusScreen
import com.example.ui.screens.VoucherScreen
import com.example.ui.theme.MyApplicationTheme

class MainActivity : ComponentActivity() {
  private val viewModel: HotspotViewModel by viewModels()

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    enableEdgeToEdge()
    setContent {
      MyApplicationTheme {
        MainAppOrchestrator(viewModel)
      }
    }
  }
}

@Composable
fun MainAppOrchestrator(viewModel: HotspotViewModel) {
  val currentScreen = viewModel.currentScreen

  Scaffold(
    modifier = Modifier.fillMaxSize(),
    bottomBar = {
      // Only show bottom navigation bar when user is logged into router
      AnimatedVisibility(
        visible = currentScreen != AppScreen.Login,
        enter = fadeIn(),
        exit = fadeOut()
      ) {
        NavigationBar(
          modifier = Modifier
            .navigationBarsPadding()
            .testTag("bottom_navigation_bar"),
          containerColor = Color.White,
          tonalElevation = 8.dp
        ) {
          // 1. HOME TAB
          NavigationBarItem(
            selected = currentScreen == AppScreen.Home,
            onClick = { viewModel.navigateTo(AppScreen.Home) },
            icon = { Icon(Icons.Default.Home, contentDescription = "Home") },
            label = { Text("Home", fontSize = 11.sp) },
            colors = NavigationBarItemDefaults.colors(
              selectedIconColor = Color(0xFF4F46E5),
              selectedTextColor = Color(0xFF4F46E5),
              indicatorColor = Color(0xFFEEF2F6),
              unselectedIconColor = Color(0xFF94A3B8),
              unselectedTextColor = Color(0xFF94A3B8)
            ),
            modifier = Modifier.testTag("nav_home")
          )

          // 2. STATUS TAB
          NavigationBarItem(
            selected = currentScreen == AppScreen.Status,
            onClick = { viewModel.navigateTo(AppScreen.Status) },
            icon = { Icon(Icons.Default.Speed, contentDescription = "Status") },
            label = { Text("Status", fontSize = 11.sp) },
            colors = NavigationBarItemDefaults.colors(
              selectedIconColor = Color(0xFF4F46E5),
              selectedTextColor = Color(0xFF4F46E5),
              indicatorColor = Color(0xFFEEF2F6),
              unselectedIconColor = Color(0xFF94A3B8),
              unselectedTextColor = Color(0xFF94A3B8)
            ),
            modifier = Modifier.testTag("nav_status")
          )

          // 3. TRANSAKSI (VOUCHER) TAB
          NavigationBarItem(
            selected = currentScreen == AppScreen.Transaksi,
            onClick = { viewModel.navigateTo(AppScreen.Transaksi) },
            icon = { Icon(Icons.Default.LocalActivity, contentDescription = "Transaksi") },
            label = { Text("Transaksi", fontSize = 11.sp) },
            colors = NavigationBarItemDefaults.colors(
              selectedIconColor = Color(0xFF4F46E5),
              selectedTextColor = Color(0xFF4F46E5),
              indicatorColor = Color(0xFFEEF2F6),
              unselectedIconColor = Color(0xFF94A3B8),
              unselectedTextColor = Color(0xFF94A3B8)
            ),
            modifier = Modifier.testTag("nav_transaksi")
          )

          // 4. AKUN TAB
          NavigationBarItem(
            selected = currentScreen == AppScreen.Akun,
            onClick = { viewModel.navigateTo(AppScreen.Akun) },
            icon = { Icon(Icons.Default.AccountCircle, contentDescription = "Akun") },
            label = { Text("Akun", fontSize = 11.sp) },
            colors = NavigationBarItemDefaults.colors(
              selectedIconColor = Color(0xFF4F46E5),
              selectedTextColor = Color(0xFF4F46E5),
              indicatorColor = Color(0xFFEEF2F6),
              unselectedIconColor = Color(0xFF94A3B8),
              unselectedTextColor = Color(0xFF94A3B8)
            ),
            modifier = Modifier.testTag("nav_akun")
          )

          // 5. SETTINGS TAB
          NavigationBarItem(
            selected = currentScreen == AppScreen.Settings,
            onClick = { viewModel.navigateTo(AppScreen.Settings) },
            icon = { Icon(Icons.Default.Settings, contentDescription = "Settings") },
            label = { Text("Settings", fontSize = 11.sp) },
            colors = NavigationBarItemDefaults.colors(
              selectedIconColor = Color(0xFF4F46E5),
              selectedTextColor = Color(0xFF4F46E5),
              indicatorColor = Color(0xFFEEF2F6),
              unselectedIconColor = Color(0xFF94A3B8),
              unselectedTextColor = Color(0xFF94A3B8)
            ),
            modifier = Modifier.testTag("nav_settings")
          )
        }
      }
    }
  ) { innerPadding ->
    Box(
      modifier = Modifier
        .fillMaxSize()
        .padding(innerPadding)
    ) {
      // Display Screens
      when (currentScreen) {
        AppScreen.Login -> LoginScreen(viewModel)
        AppScreen.Home -> HomeScreen(viewModel)
        AppScreen.Status -> StatusScreen(viewModel)
        AppScreen.Transaksi -> VoucherScreen(viewModel)
        AppScreen.Akun -> AccountScreen(viewModel)
        AppScreen.Settings -> SettingsScreen(viewModel)
      }

      // Global Notification Warning Banner Floating at top (if logged in)
      if (currentScreen != AppScreen.Login) {
        HotspotWarningBanner(
          viewModel = viewModel,
          modifier = Modifier
            .align(Alignment.TopCenter)
            .statusBarsPadding()
        )
      }
    }
  }
}

