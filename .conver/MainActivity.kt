package com.example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.animation.*
import androidx.compose.animation.core.spring
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.data.db.AppDatabase
import com.example.data.model.Notification
import com.example.data.repository.AppRepository
import com.example.ui.screens.*
import com.example.ui.theme.MyApplicationTheme
import com.example.ui.theme.TealTertiary
import com.example.ui.viewmodel.AppViewModel
import com.example.ui.viewmodel.AppViewModelFactory
import kotlinx.coroutines.delay
import kotlin.OptIn

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            MyApplicationTheme {
                val context = LocalContext.current
                
                // Initialize Database and Repository
                val database = remember { AppDatabase.getDatabase(context) }
                val repository = remember { AppRepository(database.appDao()) }
                
                // Retrieve ViewModel using Factory
                val appViewModel: AppViewModel = viewModel(
                    factory = AppViewModelFactory(repository)
                )

                val isLoggedIn by appViewModel.isLoggedIn.collectAsState()

                if (!isLoggedIn) {
                    LoginScreen(viewModel = appViewModel)
                } else {
                    MainAppScaffold(viewModel = appViewModel)
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainAppScaffold(viewModel: AppViewModel) {
    var selectedTab by remember { mutableStateOf(MainTab.HOME) }
    val notifications by viewModel.notifications.collectAsState()

    // State to track the active real-time slide-down notification
    var activeNotification by remember { mutableStateOf<Notification?>(null) }

    // Observe notifications to display real-time sliding alerts
    LaunchedEffect(notifications) {
        val latestUnread = notifications.firstOrNull { !it.isRead }
        if (latestUnread != null && latestUnread.id != activeNotification?.id) {
            activeNotification = latestUnread
            // Dismiss automatically after 4 seconds
            delay(4000)
            activeNotification = null
        }
    }

    Box(modifier = Modifier.fillMaxSize()) {
        Scaffold(
            modifier = Modifier.fillMaxSize(),
            topBar = {
                TopAppBar(
                    title = {
                        Column {
                            Text(
                                text = "GUARDIAN CONSOLE",
                                style = MaterialTheme.typography.labelSmall,
                                fontWeight = FontWeight.SemiBold,
                                color = MaterialTheme.colorScheme.primary,
                                letterSpacing = 1.5.sp
                            )
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Icon(
                                    imageVector = Icons.Default.Shield,
                                    contentDescription = null,
                                    tint = MaterialTheme.colorScheme.primary,
                                    modifier = Modifier.size(18.dp)
                                )
                                Spacer(modifier = Modifier.width(6.dp))
                                Text(
                                    text = "SecurApp Admin",
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 18.sp,
                                    color = MaterialTheme.colorScheme.onBackground
                                )
                            }
                        }
                    },
                    actions = {
                        // Notifications badge button
                        var notificationsExpanded by remember { mutableStateOf(false) }
                        val unreadCount = notifications.count { !it.isRead }

                        Box {
                            IconButton(onClick = { notificationsExpanded = true }) {
                                BadgedBox(
                                    badge = {
                                        if (unreadCount > 0) {
                                            Badge { Text("$unreadCount") }
                                        }
                                    }
                                ) {
                                    Icon(Icons.Default.Notifications, contentDescription = "Notifikasi")
                                }
                            }

                            DropdownMenu(
                                expanded = notificationsExpanded,
                                onDismissRequest = { notificationsExpanded = false },
                                modifier = Modifier.width(280.dp)
                            ) {
                                Row(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(horizontal = 12.dp, vertical = 8.dp),
                                    horizontalArrangement = Arrangement.SpaceBetween,
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Text("Aktivitas Seller", fontWeight = FontWeight.Bold, fontSize = 13.sp)
                                    TextButton(onClick = { viewModel.markAllNotificationsAsRead() }) {
                                        Text("Tandai Baca", fontSize = 11.sp)
                                    }
                                }
                                
                                HorizontalDivider()

                                if (notifications.isEmpty()) {
                                    DropdownMenuItem(
                                        text = { Text("Tidak ada notifikasi", fontSize = 12.sp) },
                                        onClick = {}
                                    )
                                } else {
                                    notifications.take(5).forEach { notif ->
                                        DropdownMenuItem(
                                            text = {
                                                Column {
                                                    Text(
                                                        text = notif.message,
                                                        fontSize = 11.sp,
                                                        lineHeight = 14.sp,
                                                        color = if (notif.isRead) MaterialTheme.colorScheme.onSurfaceVariant else MaterialTheme.colorScheme.onSurface,
                                                        fontWeight = if (notif.isRead) FontWeight.Normal else FontWeight.Bold
                                                    )
                                                }
                                            },
                                            onClick = {
                                                viewModel.dismissNotification(notif.id)
                                            }
                                        )
                                    }
                                }
                            }
                        }
                    },
                    colors = TopAppBarDefaults.topAppBarColors(
                        containerColor = MaterialTheme.colorScheme.background,
                        titleContentColor = MaterialTheme.colorScheme.onBackground
                    )
                )
            },
            bottomBar = {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(Color.Transparent)
                        .padding(start = 24.dp, end = 24.dp, bottom = 20.dp, top = 8.dp)
                        .navigationBarsPadding()
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(64.dp)
                            .background(
                                color = Color(0xFF008577), // Deep teal/emerald from screenshot
                                shape = RoundedCornerShape(32.dp)
                            )
                            .padding(horizontal = 8.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceEvenly
                    ) {
                        val items = listOf(
                            MainTab.HOME,
                            MainTab.SELLER,
                            MainTab.APPROVAL,
                            MainTab.SYSTEM,
                            MainTab.SETTINGS
                        )

                        items.forEach { tab ->
                            val isSelected = selectedTab == tab
                            Box(
                                modifier = Modifier
                                    .size(48.dp)
                                    .clip(CircleShape)
                                    .clickable { selectedTab = tab }
                                    .testTag("nav_item_${tab.title.lowercase()}"),
                                contentAlignment = Alignment.Center
                            ) {
                                if (isSelected) {
                                    Box(
                                        modifier = Modifier
                                            .size(40.dp)
                                            .background(
                                                color = Color.White.copy(alpha = 0.2f),
                                                shape = CircleShape
                                            )
                                    )
                                }
                                Icon(
                                    imageVector = if (isSelected) tab.activeIcon else tab.inactiveIcon,
                                    contentDescription = tab.title,
                                    tint = Color.White.copy(alpha = if (isSelected) 1.0f else 0.6f),
                                    modifier = Modifier.size(24.dp)
                                )
                            }
                        }
                    }
                }
            }
        ) { innerPadding ->
            // Active screen selection switcher
            val screenModifier = Modifier.padding(innerPadding)
            when (selectedTab) {
                MainTab.HOME -> HomeScreen(viewModel = viewModel, modifier = screenModifier)
                MainTab.SELLER -> SellerScreen(viewModel = viewModel, modifier = screenModifier)
                MainTab.APPROVAL -> ApprovalScreen(viewModel = viewModel, modifier = screenModifier)
                MainTab.SYSTEM -> SystemScreen(viewModel = viewModel, modifier = screenModifier)
                MainTab.SETTINGS -> SettingsScreen(viewModel = viewModel, modifier = screenModifier)
            }
        }

        // Real-time Push Alert Banner sliding down from top of screen!
        AnimatedVisibility(
            visible = activeNotification != null,
            enter = slideInVertically(
                initialOffsetY = { -it },
                animationSpec = spring(dampingRatio = 0.8f)
            ) + fadeIn(),
            exit = slideOutVertically(
                targetOffsetY = { -it }
            ) + fadeOut(),
            modifier = Modifier
                .align(Alignment.TopCenter)
                .padding(16.dp)
                .statusBarsPadding()
        ) {
            activeNotification?.let { notif ->
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .shadow(12.dp, RoundedCornerShape(16.dp)),
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
                    border = BorderStroke(1.5.dp, MaterialTheme.colorScheme.primary)
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(12.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier.weight(1f)
                        ) {
                            Box(
                                modifier = Modifier
                                    .size(36.dp)
                                    .background(
                                        color = if (notif.message.contains("BANNED")) {
                                            MaterialTheme.colorScheme.error.copy(alpha = 0.2f)
                                        } else {
                                            TealTertiary.copy(alpha = 0.2f)
                                        },
                                        shape = CircleShape
                                    ),
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(
                                    imageVector = if (notif.message.contains("BANNED")) Icons.Default.Warning else Icons.Default.Storefront,
                                    contentDescription = null,
                                    tint = if (notif.message.contains("BANNED")) MaterialTheme.colorScheme.error else TealTertiary,
                                    modifier = Modifier.size(18.dp)
                                )
                            }
                            Spacer(modifier = Modifier.width(12.dp))
                            Column {
                                Text(
                                    "Aktivitas Real-Time Seller",
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 12.sp,
                                    color = MaterialTheme.colorScheme.primary
                                )
                                Text(
                                    text = notif.message,
                                    fontSize = 11.sp,
                                    color = MaterialTheme.colorScheme.onSurface,
                                    maxLines = 2,
                                    overflow = TextOverflow.Ellipsis
                                )
                            }
                        }

                        IconButton(
                            onClick = {
                                viewModel.dismissNotification(notif.id)
                                activeNotification = null
                            }
                        ) {
                            Icon(Icons.Default.Close, contentDescription = "Tutup", modifier = Modifier.size(16.dp))
                        }
                    }
                }
            }
        }
    }
}

enum class MainTab(
    val title: String,
    val activeIcon: androidx.compose.ui.graphics.vector.ImageVector,
    val inactiveIcon: androidx.compose.ui.graphics.vector.ImageVector
) {
    HOME("Home", Icons.Default.Home, Icons.Default.Home),
    SELLER("Seller", Icons.Default.Storefront, Icons.Default.Storefront),
    APPROVAL("Approval", Icons.Default.FactCheck, Icons.Default.FactCheck),
    SYSTEM("System", Icons.Default.Lock, Icons.Default.Lock),
    SETTINGS("Settings", Icons.Default.Settings, Icons.Default.Settings)
}
