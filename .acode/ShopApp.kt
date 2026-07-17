package com.example.ui

import android.Manifest
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Map
import androidx.compose.material.icons.filled.MyLocation
import androidx.compose.material.icons.filled.Navigation
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.ShoppingBag
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material.icons.filled.Store
import androidx.compose.material.icons.filled.Backpack
import androidx.compose.material.icons.filled.Headphones
import androidx.compose.material.icons.filled.Keyboard
import androidx.compose.material.icons.filled.Watch
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Chat
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.StarHalf
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Cancel
import androidx.compose.material.icons.filled.ArrowForward
import androidx.compose.material.icons.filled.HourglassEmpty
import androidx.compose.material.icons.filled.DoneAll
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.StarBorder
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Send
import androidx.compose.material3.TextButton
import androidx.compose.runtime.mutableStateMapOf
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.IconButton
import androidx.compose.material3.IconButtonDefaults
import androidx.compose.material3.Slider
import androidx.compose.material3.SliderDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.R
import com.example.data.Product
import com.example.data.ShopConfig
import com.example.ui.theme.CyberCyan
import com.example.ui.theme.FlarePink
import com.example.ui.theme.NeonPurple
import java.util.Locale

@Composable
fun ShopApp(viewModel: ShopViewModel) {
    val currentTab by viewModel.currentTab.collectAsState()
    val context = LocalContext.current
    var showCartOverlay by remember { mutableStateOf(false) }

    // Launch location permissions setup
    val locationPermissionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestMultiplePermissions()
    ) { permissions ->
        val fineGranted = permissions[Manifest.permission.ACCESS_FINE_LOCATION] ?: false
        val coarseGranted = permissions[Manifest.permission.ACCESS_COARSE_LOCATION] ?: false
        if (fineGranted || coarseGranted) {
            viewModel.requestGpsLocation(context)
        } else {
            Toast.makeText(context, "GPS Location access denied", Toast.LENGTH_SHORT).show()
        }
    }

    Scaffold(
        modifier = Modifier.fillMaxSize(),
        bottomBar = {
            NavigationBar(
                containerColor = MaterialTheme.colorScheme.surface,
                tonalElevation = 8.dp,
                modifier = Modifier
                    .border(width = 1.dp, color = MaterialTheme.colorScheme.outline.copy(alpha = 0.1f))
            ) {
                // 1. Home tab
                NavigationBarItem(
                    selected = currentTab == "home",
                    onClick = { viewModel.currentTab.value = "home" },
                    icon = { Icon(Icons.Default.Home, contentDescription = "Home") },
                    label = { Text("Home", fontSize = 11.sp, fontWeight = FontWeight.Bold) },
                    colors = NavigationBarItemDefaults.colors(
                        selectedIconColor = CyberCyan,
                        selectedTextColor = CyberCyan,
                        unselectedIconColor = MaterialTheme.colorScheme.onSurfaceVariant,
                        unselectedTextColor = MaterialTheme.colorScheme.onSurfaceVariant,
                        indicatorColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.15f)
                    ),
                    modifier = Modifier.testTag("nav_home")
                )

                // 2. Terbaik tab
                NavigationBarItem(
                    selected = currentTab == "terbaik",
                    onClick = { viewModel.currentTab.value = "terbaik" },
                    icon = { Icon(Icons.Default.Star, contentDescription = "Terbaik") },
                    label = { Text("Terbaik", fontSize = 11.sp, fontWeight = FontWeight.Bold) },
                    colors = NavigationBarItemDefaults.colors(
                        selectedIconColor = CyberCyan,
                        selectedTextColor = CyberCyan,
                        unselectedIconColor = MaterialTheme.colorScheme.onSurfaceVariant,
                        unselectedTextColor = MaterialTheme.colorScheme.onSurfaceVariant,
                        indicatorColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.15f)
                    ),
                    modifier = Modifier.testTag("nav_terbaik")
                )

                // 3. Status tab
                val ordersList by viewModel.orders.collectAsState()
                val pendingOrders = ordersList.count { it.status == "PENDING_PICKUP" }
                NavigationBarItem(
                    selected = currentTab == "status",
                    onClick = { viewModel.currentTab.value = "status" },
                    icon = {
                        Box {
                            Icon(Icons.Default.Store, contentDescription = "Status")
                            if (pendingOrders > 0) {
                                Box(
                                    contentAlignment = Alignment.Center,
                                    modifier = Modifier
                                        .align(Alignment.TopEnd)
                                        .size(16.dp)
                                        .background(NeonPurple, CircleShape)
                                        .border(1.dp, Color.Black, CircleShape)
                                ) {
                                    Text(
                                        text = pendingOrders.toString(),
                                        color = Color.White,
                                        fontSize = 9.sp,
                                        fontWeight = FontWeight.Bold
                                    )
                                }
                            }
                        }
                    },
                    label = { Text("Status", fontSize = 11.sp, fontWeight = FontWeight.Bold) },
                    colors = NavigationBarItemDefaults.colors(
                        selectedIconColor = CyberCyan,
                        selectedTextColor = CyberCyan,
                        unselectedIconColor = MaterialTheme.colorScheme.onSurfaceVariant,
                        unselectedTextColor = MaterialTheme.colorScheme.onSurfaceVariant,
                        indicatorColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.15f)
                    ),
                    modifier = Modifier.testTag("nav_status")
                )

                // 4. Tombol4 tab (Interactive location map overlay)
                NavigationBarItem(
                    selected = currentTab == "tombol4",
                    onClick = { viewModel.currentTab.value = "tombol4" },
                    icon = { Icon(Icons.Default.Map, contentDescription = "Tombol4") },
                    label = { Text("Tombol4", fontSize = 11.sp, fontWeight = FontWeight.Bold) },
                    colors = NavigationBarItemDefaults.colors(
                        selectedIconColor = CyberCyan,
                        selectedTextColor = CyberCyan,
                        unselectedIconColor = MaterialTheme.colorScheme.onSurfaceVariant,
                        unselectedTextColor = MaterialTheme.colorScheme.onSurfaceVariant,
                        indicatorColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.15f)
                    ),
                    modifier = Modifier.testTag("nav_tombol4")
                )

                // 5. Setting tab
                NavigationBarItem(
                    selected = currentTab == "setting",
                    onClick = { viewModel.currentTab.value = "setting" },
                    icon = { Icon(Icons.Default.Settings, contentDescription = "Setting") },
                    label = { Text("Setting", fontSize = 11.sp, fontWeight = FontWeight.Bold) },
                    colors = NavigationBarItemDefaults.colors(
                        selectedIconColor = CyberCyan,
                        selectedTextColor = CyberCyan,
                        unselectedIconColor = MaterialTheme.colorScheme.onSurfaceVariant,
                        unselectedTextColor = MaterialTheme.colorScheme.onSurfaceVariant,
                        indicatorColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.15f)
                    ),
                    modifier = Modifier.testTag("nav_setting")
                )
            }
        }
    ) { innerPadding ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
        ) {
            when (currentTab) {
                "home" -> HomeTab(viewModel, onOpenCart = { showCartOverlay = true })
                "terbaik" -> TerbaikTab(viewModel, onOpenCart = { showCartOverlay = true })
                "status" -> StatusTab(viewModel)
                "tombol4" -> Tombol4Tab(viewModel, onLocationPermissionRequest = {
                    locationPermissionLauncher.launch(
                        arrayOf(
                            Manifest.permission.ACCESS_FINE_LOCATION,
                            Manifest.permission.ACCESS_COARSE_LOCATION
                        )
                    )
                })
                "setting" -> SettingTab(viewModel, onLocationPermissionRequest = {
                    locationPermissionLauncher.launch(
                        arrayOf(
                            Manifest.permission.ACCESS_FINE_LOCATION,
                            Manifest.permission.ACCESS_COARSE_LOCATION
                        )
                    )
                })
                else -> HomeTab(viewModel, onOpenCart = { showCartOverlay = true })
            }

            // Beautiful full overlay modal sheet for Cart checking & checkout action
            if (showCartOverlay) {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .background(Color.Black.copy(alpha = 0.7f))
                        .clickable { showCartOverlay = false }
                ) {
                    Box(
                        modifier = Modifier
                            .align(Alignment.BottomCenter)
                            .fillMaxWidth()
                            .fillMaxHeight(0.85f)
                            .background(
                                color = MaterialTheme.colorScheme.surface,
                                shape = RoundedCornerShape(topStart = 32.dp, topEnd = 32.dp)
                            )
                            .border(
                                1.dp,
                                MaterialTheme.colorScheme.outline.copy(alpha = 0.2f),
                                RoundedCornerShape(topStart = 32.dp, topEnd = 32.dp)
                            )
                            .clickable(enabled = false) {}
                            .padding(top = 8.dp)
                    ) {
                        Column(modifier = Modifier.fillMaxSize()) {
                            // Close bar anchor
                            Box(
                                modifier = Modifier
                                    .align(Alignment.CenterHorizontally)
                                    .width(48.dp)
                                    .height(5.dp)
                                    .background(
                                        color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.3f),
                                        shape = RoundedCornerShape(10.dp)
                                    )
                                    .clickable { showCartOverlay = false }
                            )
                            
                            Spacer(modifier = Modifier.height(16.dp))
                            
                            // Load existing CartTab directly as overlay
                            Box(modifier = Modifier.weight(1f)) {
                                CartTab(viewModel)
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun HomeTab(viewModel: ShopViewModel, onOpenCart: () -> Unit) {
    val productsList by viewModel.products.collectAsState()
    var selectedCategory by remember { mutableStateOf("All") }
    var searchQuery by remember { mutableStateOf("") }
    
    var showNotificationsDialog by remember { mutableStateOf(false) }
    var showChatDialog by remember { mutableStateOf(false) }
    
    val cartItemsCount by viewModel.cartItems.collectAsState()
    val totalCartQuantity = cartItemsCount.sumOf { it.quantity }

    val filteredProducts = productsList.filter { product ->
        val matchesCategory = selectedCategory == "All" || product.category == selectedCategory
        val matchesSearch = product.name.contains(searchQuery, ignoreCase = true) || 
                            product.description.contains(searchQuery, ignoreCase = true)
        matchesCategory && matchesSearch
    }

    Column(modifier = Modifier.fillMaxSize()) {
        // Custom Rich App Bar
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .background(MaterialTheme.colorScheme.surface)
                .padding(horizontal = 16.dp, vertical = 12.dp)
                .border(width = 1.dp, color = MaterialTheme.colorScheme.outline.copy(alpha = 0.05f)),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Column {
                Text(
                    text = "SS SHOP SPHERE",
                    fontWeight = FontWeight.Black,
                    fontSize = 18.sp,
                    color = CyberCyan,
                    letterSpacing = 1.sp
                )
                Text(
                    text = "Offline Pickup Hub",
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    fontSize = 11.sp,
                    fontWeight = FontWeight.SemiBold
                )
            }

            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                // Notifikasi Action with Badge
                IconButton(
                    onClick = { showNotificationsDialog = true },
                    colors = IconButtonDefaults.iconButtonColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f))
                ) {
                    Box {
                        Icon(Icons.Default.Notifications, contentDescription = "Notifikasi", tint = CyberCyan)
                        Box(
                            modifier = Modifier
                                .align(Alignment.TopEnd)
                                .size(8.dp)
                                .background(FlarePink, CircleShape)
                        )
                    }
                }

                // Chat Action with Badge
                IconButton(
                    onClick = { showChatDialog = true },
                    colors = IconButtonDefaults.iconButtonColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f))
                ) {
                    Box {
                        Icon(Icons.Default.Chat, contentDescription = "Chat", tint = CyberCyan)
                        Box(
                            modifier = Modifier
                                .align(Alignment.TopEnd)
                                .size(8.dp)
                                .background(NeonPurple, CircleShape)
                        )
                    }
                }

                // Chart/Cart Action with Numeric Badge
                IconButton(
                    onClick = onOpenCart,
                    colors = IconButtonDefaults.iconButtonColors(containerColor = CyberCyan.copy(alpha = 0.15f))
                ) {
                    Box {
                        Icon(Icons.Default.ShoppingCart, contentDescription = "Cart", tint = CyberCyan)
                        if (totalCartQuantity > 0) {
                            Box(
                                contentAlignment = Alignment.Center,
                                modifier = Modifier
                                    .align(Alignment.TopEnd)
                                    .size(16.dp)
                                    .background(FlarePink, CircleShape)
                                    .border(1.dp, Color.Black, CircleShape)
                            ) {
                                Text(
                                    text = totalCartQuantity.toString(),
                                    color = Color.White,
                                    fontSize = 8.sp,
                                    fontWeight = FontWeight.Black
                                )
                            }
                        }
                    }
                }
            }
        }

        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .weight(1f)
        ) {
            // Search Bar Component
            item {
                OutlinedTextField(
                    value = searchQuery,
                    onValueChange = { searchQuery = it },
                    placeholder = { Text("Cari barang dagangan seller...", color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.7f)) },
                    leadingIcon = { Icon(Icons.Default.Search, contentDescription = "Cari", tint = CyberCyan) },
                    trailingIcon = {
                        if (searchQuery.isNotEmpty()) {
                            IconButton(onClick = { searchQuery = "" }) {
                                Icon(Icons.Default.Cancel, contentDescription = "Clear", tint = MaterialTheme.colorScheme.onSurfaceVariant)
                            }
                        }
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(start = 16.dp, end = 16.dp, top = 16.dp, bottom = 8.dp)
                        .testTag("home_search_input"),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = CyberCyan,
                        unfocusedBorderColor = MaterialTheme.colorScheme.outline.copy(alpha = 0.3f),
                        focusedContainerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.2f),
                        unfocusedContainerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.2f)
                    ),
                    shape = RoundedCornerShape(24.dp),
                    singleLine = true
                )
            }

            // Hero Banner / Promo Carousel Penawaran
            item {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(start = 16.dp, end = 16.dp, top = 8.dp, bottom = 16.dp)
                        .height(130.dp)
                        .clip(RoundedCornerShape(20.dp))
                        .background(
                            Brush.linearGradient(
                                colors = listOf(NeonPurple.copy(alpha = 0.85f), FlarePink.copy(alpha = 0.85f))
                            )
                        )
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(16.dp),
                        verticalArrangement = Arrangement.Center
                    ) {
                        Text(
                            text = "🎁 PENAWARAN KHUSUS JEMPUT",
                            fontWeight = FontWeight.Black,
                            fontSize = 14.sp,
                            color = CyberCyan
                        )
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            text = "Potongan Rp 50.000 & Bebas Ongkir",
                            fontWeight = FontWeight.Black,
                            fontSize = 18.sp,
                            color = Color.White
                        )
                        Spacer(modifier = Modifier.height(2.dp))
                        Text(
                            text = "Untuk semua pickup di dalam radius toko seller. Cek lokasimu sekarang!",
                            fontSize = 11.sp,
                            color = Color.White.copy(alpha = 0.9f),
                            lineHeight = 15.sp
                        )
                    }
                    
                    // Floating small accent badge
                    Box(
                        modifier = Modifier
                            .align(Alignment.BottomEnd)
                            .padding(12.dp)
                            .background(Color.Black.copy(alpha = 0.4f), RoundedCornerShape(10.dp))
                            .padding(horizontal = 8.dp, vertical = 4.dp)
                    ) {
                        Text("Active Promo", color = CyberCyan, fontSize = 9.sp, fontWeight = FontWeight.Bold)
                    }
                }
            }

            // Categories Section Title
            item {
                Text(
                    text = "Kategori Pilihan",
                    fontWeight = FontWeight.Black,
                    fontSize = 14.sp,
                    color = MaterialTheme.colorScheme.onSurface,
                    modifier = Modifier.padding(start = 16.dp, top = 4.dp, bottom = 8.dp)
                )
            }

            // Horizontal Categories list
            item {
                Row(
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 4.dp)
                ) {
                    val categories = listOf("All", "Electronics", "Accessories", "Lifestyle")
                    categories.forEach { category ->
                        CategoryChip(
                            category = category,
                            isSelected = selectedCategory == category,
                            onClick = { selectedCategory = category },
                            modifier = Modifier.weight(1f)
                        )
                    }
                }
            }

            // Product List Grid Title
            item {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(start = 16.dp, end = 16.dp, top = 20.dp, bottom = 10.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Barang Dagangan Seller",
                        fontWeight = FontWeight.Black,
                        fontSize = 15.sp,
                        color = CyberCyan
                    )
                    Text(
                        text = "${filteredProducts.size} Items",
                        fontSize = 11.sp,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }

            // Products items rendered as vertical list of rows or inline pseudo-grid
            if (filteredProducts.isEmpty()) {
                item {
                    Box(
                        contentAlignment = Alignment.Center,
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(200.dp)
                    ) {
                        Text(
                            text = "Tidak ada produk yang cocok dengan pencarian Anda.",
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            fontSize = 12.sp
                        )
                    }
                }
            } else {
                // Render products in chunks of 2 for grid look in LazyColumn
                val chunks = filteredProducts.chunked(2)
                items(chunks) { rowItems ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 16.dp, vertical = 6.dp),
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        for (product in rowItems) {
                            Box(modifier = Modifier.weight(1f)) {
                                ProductCard(
                                    product = product,
                                    onAddToCart = { viewModel.addToCart(product.id) }
                                )
                            }
                        }
                        if (rowItems.size < 2) {
                            Spacer(modifier = Modifier.weight(1f))
                        }
                    }
                }
            }
        }
    }

    // Interactive Notifications Dialog Simulator
    if (showNotificationsDialog) {
        androidx.compose.material3.AlertDialog(
            onDismissRequest = { showNotificationsDialog = false },
            title = {
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Icon(Icons.Default.Notifications, contentDescription = null, tint = CyberCyan)
                    Text("Notifikasi Sphere Hub", fontWeight = FontWeight.Black, fontSize = 16.sp)
                }
            },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                    Card(colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f))) {
                        Column(modifier = Modifier.padding(10.dp)) {
                            Text("🚚 UPDATE PACKING SELLER", fontWeight = FontWeight.Bold, fontSize = 11.sp, color = NeonPurple)
                            Text("Pesanan Anda #10001 sedang dalam proses packing oleh seller Coffee Sphere.", fontSize = 12.sp)
                        }
                    }
                    Card(colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f))) {
                        Column(modifier = Modifier.padding(10.dp)) {
                            Text("🎉 PROMO SEKITAR ANDA", fontWeight = FontWeight.Bold, fontSize = 11.sp, color = FlarePink)
                            Text("Gunakan voucher 'SPHEREJEMPUT' untuk diskon langsung Rp 15.000 khusus self pickup.", fontSize = 12.sp)
                        }
                    }
                }
            },
            confirmButton = {
                Button(
                    onClick = { showNotificationsDialog = false },
                    colors = ButtonDefaults.buttonColors(containerColor = CyberCyan, contentColor = Color.Black)
                ) {
                    Text("Tutup", fontWeight = FontWeight.Bold)
                }
            }
        )
    }

    // Interactive Chat Simulator Dialog
    if (showChatDialog) {
        androidx.compose.material3.AlertDialog(
            onDismissRequest = { showChatDialog = false },
            title = {
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Icon(Icons.Default.Chat, contentDescription = null, tint = CyberCyan)
                    Text("Chat dengan Seller", fontWeight = FontWeight.Black, fontSize = 16.sp)
                }
            },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.height(220.dp).verticalScroll(rememberScrollState())) {
                    // Seller chat bubble
                    Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.CenterStart) {
                        Card(colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant), shape = RoundedCornerShape(12.dp)) {
                            Text("Halo kak! Selamat datang di toko SS Shop Sphere. Ada yang bisa kami bantu hari ini?", modifier = Modifier.padding(8.dp), fontSize = 11.sp)
                        }
                    }
                    // Buyer chat bubble
                    Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.CenterEnd) {
                        Card(colors = CardDefaults.cardColors(containerColor = CyberCyan.copy(alpha = 0.15f)), shape = RoundedCornerShape(12.dp)) {
                            Text("Halo, saya mau jemput pesanan jam tangan. Apakah stock produk SS Sphere Watch v2 aman?", modifier = Modifier.padding(8.dp), fontSize = 11.sp)
                        }
                    }
                    // Seller response
                    Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.CenterStart) {
                        Card(colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant), shape = RoundedCornerShape(12.dp)) {
                            Text("Sangat aman kak! Kami siap packing seketika setelah kakak order di radius valid kami. Silakan dipesan ya!", modifier = Modifier.padding(8.dp), fontSize = 11.sp)
                        }
                    }
                }
            },
            confirmButton = {
                Button(
                    onClick = { showChatDialog = false },
                    colors = ButtonDefaults.buttonColors(containerColor = CyberCyan, contentColor = Color.Black)
                ) {
                    Text("Selesai Chat", fontWeight = FontWeight.Bold)
                }
            }
        )
    }
}

@Composable
fun TerbaikTab(viewModel: ShopViewModel, onOpenCart: () -> Unit) {
    val productsList by viewModel.products.collectAsState()
    val distanceVal by viewModel.distanceToShop.collectAsState()
    val shopConf by viewModel.shopConfig.collectAsState()
    
    var searchQuery by remember { mutableStateOf("") }
    
    val cartItemsCount by viewModel.cartItems.collectAsState()
    val totalCartQuantity = cartItemsCount.sumOf { it.quantity }
    
    // Sort products by mock ratings (we can assign rating based on name/id)
    val sortedProducts = productsList.map { product ->
        val rating = when (product.id % 4) {
            0 -> 5.0
            1 -> 4.9
            2 -> 4.8
            else -> 4.7
        }
        val reviewCount = 20 + (product.id * 17) % 150
        Triple(product, rating, reviewCount)
    }.sortedByDescending { it.second }
    
    val filteredProducts = sortedProducts.filter { (product, _, _) ->
        product.name.contains(searchQuery, ignoreCase = true) ||
        product.description.contains(searchQuery, ignoreCase = true)
    }

    Column(modifier = Modifier.fillMaxSize()) {
        // App Bar with Search Bar built-in
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .background(MaterialTheme.colorScheme.surface)
                .padding(horizontal = 16.dp, vertical = 10.dp)
                .border(width = 1.dp, color = MaterialTheme.colorScheme.outline.copy(alpha = 0.05f)),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            // Search field
            OutlinedTextField(
                value = searchQuery,
                onValueChange = { searchQuery = it },
                placeholder = { Text("Cari produk terbaik...", fontSize = 13.sp, color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.7f)) },
                leadingIcon = { Icon(Icons.Default.Search, contentDescription = null, tint = CyberCyan, modifier = Modifier.size(20.dp)) },
                modifier = Modifier
                    .weight(1f)
                    .height(50.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedBorderColor = CyberCyan,
                    unfocusedBorderColor = MaterialTheme.colorScheme.outline.copy(alpha = 0.2f),
                    focusedContainerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.15f),
                    unfocusedContainerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.15f)
                ),
                shape = RoundedCornerShape(20.dp),
                singleLine = true
            )

            // Shopping bag with badge
            IconButton(
                onClick = onOpenCart,
                colors = IconButtonDefaults.iconButtonColors(containerColor = CyberCyan.copy(alpha = 0.15f)),
                modifier = Modifier.size(45.dp)
            ) {
                Box {
                    Icon(Icons.Default.ShoppingCart, contentDescription = "Cart", tint = CyberCyan)
                    if (totalCartQuantity > 0) {
                        Box(
                            contentAlignment = Alignment.Center,
                            modifier = Modifier
                                .align(Alignment.TopEnd)
                                .size(16.dp)
                                .background(FlarePink, CircleShape)
                                .border(1.dp, Color.Black, CircleShape)
                        ) {
                            Text(
                                text = totalCartQuantity.toString(),
                                color = Color.White,
                                fontSize = 8.sp,
                                fontWeight = FontWeight.Black
                            )
                        }
                    }
                }
            }
        }

        LazyColumn(
            contentPadding = PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(14.dp),
            modifier = Modifier.fillMaxSize()
        ) {
            item {
                Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                    Column {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            Icon(Icons.Default.Star, contentDescription = null, tint = CyberCyan)
                            Text(
                                text = "Terbaik di Sekitar Anda",
                                fontWeight = FontWeight.Black,
                                fontSize = 18.sp,
                                color = Color.White
                            )
                        }
                        Text(
                            text = "Barang dagangan seller dengan rating bintang tertinggi & terdekat dari lokasimu saat ini.",
                            fontSize = 12.sp,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            modifier = Modifier.padding(top = 4.dp, bottom = 4.dp)
                        )
                    }

                    // Stunning Radius Indicator Card
                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .border(
                                width = 1.5.dp,
                                color = if (distanceVal <= shopConf.maxCheckoutRadiusMeters) CyberCyan else FlarePink,
                                shape = RoundedCornerShape(24.dp)
                            ),
                        colors = CardDefaults.cardColors(
                            containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.35f)
                        ),
                        shape = RoundedCornerShape(24.dp)
                    ) {
                        Column(modifier = Modifier.padding(16.dp)) {
                            Row(
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically,
                                modifier = Modifier.fillMaxWidth()
                            ) {
                                Row(
                                    verticalAlignment = Alignment.CenterVertically,
                                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                                ) {
                                    Icon(
                                        imageVector = Icons.Default.MyLocation,
                                        contentDescription = null,
                                        tint = if (distanceVal <= shopConf.maxCheckoutRadiusMeters) CyberCyan else FlarePink,
                                        modifier = Modifier.size(20.dp)
                                    )
                                    Text(
                                        text = "Status Radius Anda",
                                        fontWeight = FontWeight.Black,
                                        fontSize = 14.sp,
                                        color = Color.White
                                    )
                                }
                                
                                val inRadius = distanceVal <= shopConf.maxCheckoutRadiusMeters
                                Box(
                                    modifier = Modifier
                                        .background(
                                            color = if (inRadius) CyberCyan.copy(alpha = 0.2f) else FlarePink.copy(alpha = 0.2f),
                                            shape = RoundedCornerShape(8.dp)
                                        )
                                        .padding(horizontal = 8.dp, vertical = 4.dp)
                                ) {
                                    Text(
                                        text = if (inRadius) "DALAM RADIUS" else "LUAR RADIUS",
                                        color = if (inRadius) CyberCyan else FlarePink,
                                        fontSize = 10.sp,
                                        fontWeight = FontWeight.Black
                                    )
                                }
                            }
                            
                            Spacer(modifier = Modifier.height(12.dp))
                            
                            // Distance & Radius limit info
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                Column {
                                    Text("Jarak ke Seller", fontSize = 10.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                                    val formattedDistance = if (distanceVal > 1000.0) {
                                        String.format(Locale.US, "%.2f km", distanceVal / 1000.0)
                                    } else {
                                        String.format(Locale.US, "%.0f meter", distanceVal)
                                    }
                                    Text(
                                        text = formattedDistance,
                                        fontSize = 16.sp,
                                        fontWeight = FontWeight.Black,
                                        color = Color.White
                                    )
                                }
                                Column(horizontalAlignment = Alignment.End) {
                                    Text("Batas Maksimal Radius", fontSize = 10.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                                    Text(
                                        text = "${shopConf.maxCheckoutRadiusMeters} m",
                                        fontSize = 16.sp,
                                        fontWeight = FontWeight.Black,
                                        color = NeonPurple
                                    )
                                }
                            }
                            
                            Spacer(modifier = Modifier.height(12.dp))
                            
                            // Visual Progress Bar representing current distance relative to maximum radius
                            val progress = (distanceVal / shopConf.maxCheckoutRadiusMeters.toDouble()).coerceIn(0.0, 1.0).toFloat()
                            Box(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height(6.dp)
                                    .background(MaterialTheme.colorScheme.outline.copy(alpha = 0.1f), CircleShape)
                            ) {
                                Box(
                                    modifier = Modifier
                                        .fillMaxHeight()
                                        .fillMaxWidth(progress)
                                        .background(
                                            brush = Brush.horizontalGradient(
                                                colors = listOf(CyberCyan, NeonPurple)
                                            ),
                                            shape = CircleShape
                                        )
                                )
                            }
                            
                            Spacer(modifier = Modifier.height(10.dp))
                            
                            Text(
                                text = if (distanceVal <= shopConf.maxCheckoutRadiusMeters) {
                                    "Anda berada dalam radius aman! Anda bebas memilih barang dagangan terbaik di sekitar Anda & melakukan checkout instant."
                                } else {
                                    "Jarak Anda melebihi batas maksimal radius pickup seller. Silakan dekati lokasi toko seller atau sesuaikan lokasi di menu Tombol4/Setting."
                                },
                                fontSize = 10.5.sp,
                                lineHeight = 14.sp,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }
                }
            }

            // Products rendering
            if (filteredProducts.isEmpty()) {
                item {
                    Box(
                        contentAlignment = Alignment.Center,
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(200.dp)
                    ) {
                        Text("Tidak ada produk terbaik yang cocok.", color = MaterialTheme.colorScheme.onSurfaceVariant)
                    }
                }
            } else {
                items(filteredProducts) { (product, rating, reviews) ->
                    // Beautiful list item card
                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .border(width = 1.dp, color = CyberCyan.copy(alpha = 0.15f), shape = RoundedCornerShape(20.dp)),
                        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.3f)),
                        shape = RoundedCornerShape(20.dp)
                    ) {
                        Column(modifier = Modifier.padding(14.dp)) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.Top
                            ) {
                                Column(modifier = Modifier.weight(1f)) {
                                    // Tag list
                                    Row(
                                        horizontalArrangement = Arrangement.spacedBy(6.dp),
                                        verticalAlignment = Alignment.CenterVertically
                                    ) {
                                        Box(
                                            modifier = Modifier
                                                .background(CyberCyan.copy(alpha = 0.15f), RoundedCornerShape(6.dp))
                                                .padding(horizontal = 6.dp, vertical = 2.dp)
                                        ) {
                                            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(2.dp)) {
                                                Icon(Icons.Default.Star, contentDescription = null, tint = CyberCyan, modifier = Modifier.size(10.dp))
                                                Text(
                                                    text = "$rating",
                                                    color = CyberCyan,
                                                    fontWeight = FontWeight.Black,
                                                    fontSize = 10.sp
                                                )
                                            }
                                        }
                                        
                                        // Distance tag
                                        val formattedDistance = if (distanceVal > 1000.0) {
                                            String.format(Locale.US, "%.1f km", distanceVal / 1000.0)
                                        } else {
                                            String.format(Locale.US, "%.0f m", distanceVal)
                                        }
                                        val inRadius = distanceVal <= shopConf.maxCheckoutRadiusMeters
                                        
                                        Box(
                                            modifier = Modifier
                                                .background(
                                                    color = if (inRadius) NeonPurple.copy(alpha = 0.15f) else FlarePink.copy(alpha = 0.15f),
                                                    shape = RoundedCornerShape(6.dp)
                                                )
                                                .padding(horizontal = 6.dp, vertical = 2.dp)
                                        ) {
                                            Text(
                                                text = "📍 $formattedDistance",
                                                color = if (inRadius) CyberCyan else FlarePink,
                                                fontWeight = FontWeight.Bold,
                                                fontSize = 10.sp
                                            )
                                        }
                                    }
                                    
                                    Spacer(modifier = Modifier.height(8.dp))
                                    
                                    Text(
                                        text = product.name,
                                        fontWeight = FontWeight.Black,
                                        fontSize = 16.sp,
                                        color = Color.White
                                    )
                                    Text(
                                        text = product.description,
                                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                                        fontSize = 11.sp,
                                        maxLines = 2,
                                        lineHeight = 15.sp,
                                        modifier = Modifier.padding(top = 2.dp)
                                    )
                                }
                                
                                // Price & Action Block on the Right
                                Column(
                                    horizontalAlignment = Alignment.End,
                                    verticalArrangement = Arrangement.spacedBy(10.dp)
                                ) {
                                    Text(
                                        text = formatRupiah(product.price),
                                        fontWeight = FontWeight.Black,
                                        fontSize = 14.sp,
                                        color = CyberCyan
                                    )
                                    
                                    Button(
                                        onClick = { viewModel.addToCart(product.id) },
                                        colors = ButtonDefaults.buttonColors(containerColor = CyberCyan, contentColor = Color.Black),
                                        shape = RoundedCornerShape(12.dp),
                                        contentPadding = PaddingValues(horizontal = 12.dp, vertical = 4.dp),
                                        modifier = Modifier.height(32.dp)
                                    ) {
                                        Text("Jemput", fontWeight = FontWeight.Bold, fontSize = 11.sp)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun CartTab(viewModel: ShopViewModel) {
    val cartUiItems by viewModel.cartUiState.collectAsState()
    val totalPriceVal by viewModel.totalPrice.collectAsState()
    val distanceVal by viewModel.distanceToShop.collectAsState()
    val shopConf by viewModel.shopConfig.collectAsState()
    val canCheckoutVal by viewModel.canCheckout.collectAsState()
    val currentTab = viewModel.currentTab

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        Text(
            text = "Your Collection Basket",
            fontWeight = FontWeight.Black,
            fontSize = 20.sp,
            color = CyberCyan,
            modifier = Modifier.padding(bottom = 12.dp)
        )

        if (cartUiItems.isEmpty()) {
            Box(
                contentAlignment = Alignment.Center,
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f)
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center,
                    modifier = Modifier.padding(24.dp)
                ) {
                    Icon(
                        Icons.Default.ShoppingCart,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.4f),
                        modifier = Modifier.size(72.dp)
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                    Text(
                        text = "Your Cart is Empty",
                        fontWeight = FontWeight.Bold,
                        fontSize = 16.sp
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Browse our high-tech sphere products and add items to your cart to begin pickup scheduling.",
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        fontSize = 12.sp,
                        textAlign = TextAlign.Center,
                        lineHeight = 18.sp
                    )
                    Spacer(modifier = Modifier.height(24.dp))
                    Button(
                        onClick = { currentTab.value = "products" },
                        colors = ButtonDefaults.buttonColors(containerColor = CyberCyan, contentColor = Color.Black),
                        shape = RoundedCornerShape(12.dp)
                    ) {
                        Text("Browse Catalog", fontWeight = FontWeight.Bold)
                    }
                }
            }
        } else {
            // Cart items list
            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(10.dp),
                modifier = Modifier.weight(1f)
            ) {
                items(cartUiItems) { (product, quantity) ->
                    // Find cartItem ID to update
                    val cartItemsList by viewModel.cartItems.collectAsState()
                    val cItem = cartItemsList.find { it.productId == product.id }
                    if (cItem != null) {
                        CartItemCard(
                            product = product,
                            quantity = quantity,
                            onIncrease = { viewModel.updateCartQuantity(cItem.id, quantity + 1) },
                            onDecrease = { viewModel.updateCartQuantity(cItem.id, quantity - 1) },
                            onRemove = { viewModel.removeCartItem(cItem.id) }
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Dynamic Pickup / Radius Requirements Box
            Card(
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f)
                ),
                modifier = Modifier
                    .fillMaxWidth()
                    .border(
                        width = 1.dp,
                        color = if (distanceVal <= shopConf.maxCheckoutRadiusMeters) CyberCyan.copy(alpha = 0.3f) else FlarePink.copy(alpha = 0.3f),
                        shape = RoundedCornerShape(16.dp)
                    )
            ) {
                Column(modifier = Modifier.padding(14.dp)) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            Icon(
                                imageVector = Icons.Default.LocationOn,
                                contentDescription = null,
                                tint = if (distanceVal <= shopConf.maxCheckoutRadiusMeters) CyberCyan else FlarePink
                            )
                            Text(
                                text = "Pickup Location Validation",
                                fontWeight = FontWeight.Bold,
                                fontSize = 13.sp
                            )
                        }
                        
                        // Status Text
                        Text(
                            text = if (distanceVal <= shopConf.maxCheckoutRadiusMeters) "VALID" else "TOO FAR",
                            fontWeight = FontWeight.Black,
                            fontSize = 11.sp,
                            color = if (distanceVal <= shopConf.maxCheckoutRadiusMeters) CyberCyan else FlarePink
                        )
                    }
                    
                    Spacer(modifier = Modifier.height(8.dp))
                    
                    Text(
                        text = "Because this is an offline store pick-up system, checkout is restricted to a physical radius.",
                        fontSize = 11.sp,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    
                    Spacer(modifier = Modifier.height(10.dp))
                    
                    Row(
                        horizontalArrangement = Arrangement.SpaceBetween,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Column {
                            Text("Your Distance", fontSize = 10.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                            Text(
                                text = String.format(Locale.US, "%.2f km", distanceVal / 1000.0),
                                fontWeight = FontWeight.Black,
                                fontSize = 14.sp,
                                color = if (distanceVal <= shopConf.maxCheckoutRadiusMeters) CyberCyan else FlarePink
                            )
                        }
                        
                        Column(horizontalAlignment = Alignment.End) {
                            Text("Required Limit", fontSize = 10.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                            Text(
                                text = String.format(Locale.US, "Within %.1f km", shopConf.maxCheckoutRadiusMeters / 1000.0),
                                fontWeight = FontWeight.Black,
                                fontSize = 14.sp,
                                color = Color.White
                            )
                        }
                    }
                    
                    // Quick Action Presets to allow emulator user to easily test inside/outside radius checkout checks
                    Spacer(modifier = Modifier.height(12.dp))
                    HorizontalDivider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.1f))
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Quick Map Location Presets (Simulate for testing):",
                        fontSize = 10.sp,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Spacer(modifier = Modifier.height(6.dp))
                    Row(
                        horizontalArrangement = Arrangement.spacedBy(8.dp),
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Button(
                            onClick = {
                                // Monas: roughly 3 km from shop (inside radius)
                                viewModel.selectPresetBuyerLocation(-6.1754, 106.8272, "Monas (Within Radius)")
                            },
                            colors = ButtonDefaults.buttonColors(
                                containerColor = if (distanceVal <= shopConf.maxCheckoutRadiusMeters) CyberCyan.copy(alpha = 0.2f) else MaterialTheme.colorScheme.surfaceVariant,
                                contentColor = if (distanceVal <= shopConf.maxCheckoutRadiusMeters) CyberCyan else MaterialTheme.colorScheme.onSurfaceVariant
                            ),
                            shape = RoundedCornerShape(8.dp),
                            contentPadding = PaddingValues(horizontal = 10.dp, vertical = 4.dp),
                            modifier = Modifier.weight(1f).height(32.dp)
                        ) {
                            Text("Monas (Within)", fontSize = 10.sp, fontWeight = FontWeight.Bold)
                        }
                        
                        Button(
                            onClick = {
                                // Depok: roughly 22 km from shop (outside radius)
                                viewModel.selectPresetBuyerLocation(-6.4025, 106.7942, "Depok (Outside Radius)")
                            },
                            colors = ButtonDefaults.buttonColors(
                                containerColor = if (distanceVal > shopConf.maxCheckoutRadiusMeters) FlarePink.copy(alpha = 0.2f) else MaterialTheme.colorScheme.surfaceVariant,
                                contentColor = if (distanceVal > shopConf.maxCheckoutRadiusMeters) FlarePink else MaterialTheme.colorScheme.onSurfaceVariant
                            ),
                            shape = RoundedCornerShape(8.dp),
                            contentPadding = PaddingValues(horizontal = 10.dp, vertical = 4.dp),
                            modifier = Modifier.weight(1f).height(32.dp)
                        ) {
                            Text("Depok (Outside)", fontSize = 10.sp, fontWeight = FontWeight.Bold)
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(14.dp))

            // Pricing details card
            Card(
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
                modifier = Modifier
                    .fillMaxWidth()
                    .border(1.dp, MaterialTheme.colorScheme.outline.copy(alpha = 0.1f), RoundedCornerShape(16.dp))
            ) {
                Column(modifier = Modifier.padding(14.dp)) {
                    Row(
                        horizontalArrangement = Arrangement.SpaceBetween,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("Subtotal", fontSize = 13.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                        Text(formatRupiah(totalPriceVal), fontSize = 13.sp, fontWeight = FontWeight.Bold)
                    }
                    Spacer(modifier = Modifier.height(4.dp))
                    Row(
                        horizontalArrangement = Arrangement.SpaceBetween,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("Shipping / Delivery Fee", fontSize = 13.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                        Text("Rp 0 (Self-Pickup)", fontSize = 13.sp, fontWeight = FontWeight.Black, color = CyberCyan)
                    }
                    
                    HorizontalDivider(color = MaterialTheme.colorScheme.outline.copy(alpha = 0.1f), modifier = Modifier.padding(vertical = 10.dp))
                    
                    Row(
                        horizontalArrangement = Arrangement.SpaceBetween,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("Total Bill:", fontSize = 14.sp, fontWeight = FontWeight.Bold)
                        Text(
                            text = formatRupiah(totalPriceVal),
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Black,
                            color = CyberCyan
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(14.dp))

            // Dynamic Checkout Action Button
            Button(
                onClick = { viewModel.checkout() },
                enabled = canCheckoutVal,
                colors = ButtonDefaults.buttonColors(
                    containerColor = CyberCyan,
                    contentColor = Color.Black,
                    disabledContainerColor = MaterialTheme.colorScheme.surfaceVariant,
                    disabledContentColor = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.5f)
                ),
                shape = RoundedCornerShape(14.dp),
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp)
                    .testTag("checkout_button")
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Icon(Icons.Default.Store, contentDescription = null)
                    Text(
                        text = if (canCheckoutVal) "Place Order & Get Pickup Code" else "Checkout Disabled: Within Distance Required",
                        fontWeight = FontWeight.Black,
                        fontSize = 14.sp,
                        letterSpacing = 0.5.sp
                    )
                }
            }
        }
    }
}

@Composable
fun Tombol4Tab(viewModel: ShopViewModel, onLocationPermissionRequest: () -> Unit) {
    val shopConf by viewModel.shopConfig.collectAsState()
    val buyerLat by viewModel.buyerLatitude.collectAsState()
    val buyerLng by viewModel.buyerLongitude.collectAsState()
    val radiusVal by viewModel.distanceToShop.collectAsState()
    val isUsingGpsVal by viewModel.isUsingGps.collectAsState()
    val context = LocalContext.current

    // Local controller states to edit Shop Config
    var isEditingShop by remember { mutableStateOf(false) }
    var shopNameInput by remember { mutableStateOf(shopConf.name) }
    var shopAddressInput by remember { mutableStateOf(shopConf.address) }
    var shopLatInput by remember { mutableStateOf(shopConf.latitude.toString()) }
    var shopLngInput by remember { mutableStateOf(shopConf.longitude.toString()) }
    var shopRadiusInput by remember { mutableStateOf(shopConf.maxCheckoutRadiusMeters.toString()) }

    // Sync input when database config loaded
    LaunchedEffect(shopConf, isEditingShop) {
        if (!isEditingShop) {
            shopNameInput = shopConf.name
            shopAddressInput = shopConf.address
            shopLatInput = shopConf.latitude.toString()
            shopLngInput = shopConf.longitude.toString()
            shopRadiusInput = shopConf.maxCheckoutRadiusMeters.toString()
        }
    }

    Column(modifier = Modifier.fillMaxSize()) {
        // Interactive Canvas Map Component (takes majority size)
        InteractiveMap(
            shop = shopConf,
            buyerLat = buyerLat,
            buyerLng = buyerLng,
            radiusMeters = shopConf.maxCheckoutRadiusMeters,
            onMapTap = { tappedLat, tappedLng ->
                viewModel.selectPresetBuyerLocation(tappedLat, tappedLng, "Tapped Pin")
            },
            modifier = Modifier.weight(1.3f)
        )
        
        // Control HUD Bottom Section
        Column(
            modifier = Modifier
                .weight(1f)
                .background(MaterialTheme.colorScheme.surface)
                .border(width = 1.dp, color = MaterialTheme.colorScheme.outline.copy(alpha = 0.1f))
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
        ) {
            if (!isEditingShop) {
                // Info Panel
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.SpaceBetween,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Column {
                        Text(
                            text = "SS Shop Location Configuration",
                            fontWeight = FontWeight.Black,
                            fontSize = 16.sp,
                            color = CyberCyan
                        )
                        Text(
                            text = shopConf.address,
                            fontSize = 12.sp,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                    
                    IconButton(
                        onClick = { isEditingShop = true },
                        colors = IconButtonDefaults.iconButtonColors(
                            containerColor = MaterialTheme.colorScheme.surfaceVariant
                        )
                    ) {
                        Icon(
                            imageVector = Icons.Default.Settings,
                            contentDescription = "Edit Config",
                            tint = CyberCyan
                        )
                    }
                }
                
                Spacer(modifier = Modifier.height(12.dp))
                
                // Location Details Row
                Row(
                    horizontalArrangement = Arrangement.spacedBy(10.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    // Buyer Location HUD
                    Card(
                        modifier = Modifier.weight(1f),
                        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f))
                    ) {
                        Column(modifier = Modifier.padding(10.dp)) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Icon(Icons.Default.MyLocation, contentDescription = null, tint = CyberCyan, modifier = Modifier.size(14.dp))
                                Spacer(modifier = Modifier.width(4.dp))
                                Text("Buyer Point", fontWeight = FontWeight.Bold, fontSize = 11.sp, color = CyberCyan)
                            }
                            Spacer(modifier = Modifier.height(4.dp))
                            Text(
                                text = String.format(Locale.US, "%.5f, %.5f", buyerLat, buyerLng),
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Bold
                            )
                            Text(
                                text = if (isUsingGpsVal) "Source: Live GPS" else "Source: Canvas Simulator",
                                fontSize = 10.sp,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }
                    
                    // Shop Location HUD
                    Card(
                        modifier = Modifier.weight(1f),
                        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f))
                    ) {
                        Column(modifier = Modifier.padding(10.dp)) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Icon(Icons.Default.Store, contentDescription = null, tint = FlarePink, modifier = Modifier.size(14.dp))
                                Spacer(modifier = Modifier.width(4.dp))
                                Text("Seller Point", fontWeight = FontWeight.Bold, fontSize = 11.sp, color = FlarePink)
                            }
                            Spacer(modifier = Modifier.height(4.dp))
                            Text(
                                text = String.format(Locale.US, "%.5f, %.5f", shopConf.latitude, shopConf.longitude),
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Bold
                            )
                            Text(
                                text = "Max Radius: ${shopConf.maxCheckoutRadiusMeters / 1000.0} km",
                                fontSize = 10.sp,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }
                }
                
                Spacer(modifier = Modifier.height(14.dp))
                
                // Action row (Sync GPS + Open External Turn-by-Turn maps)
                Row(
                    horizontalArrangement = Arrangement.spacedBy(10.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    // Sync GPS Location Button
                    Button(
                        onClick = { onLocationPermissionRequest() },
                        colors = ButtonDefaults.buttonColors(
                            containerColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.15f),
                            contentColor = CyberCyan
                        ),
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier.weight(1.2f)
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                            Icon(Icons.Default.MyLocation, contentDescription = null, modifier = Modifier.size(16.dp))
                            Text("Sync Real GPS", fontWeight = FontWeight.Bold, fontSize = 12.sp)
                        }
                    }
                    
                    // Turn-by-turn External Intent Navigation
                    Button(
                        onClick = { viewModel.openNavigationIntent(context) },
                        colors = ButtonDefaults.buttonColors(
                            containerColor = CyberCyan,
                            contentColor = Color.Black
                        ),
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier.weight(1.5f)
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                            Icon(Icons.Default.Navigation, contentDescription = null, modifier = Modifier.size(16.dp))
                            Text("Start GPS Navigation", fontWeight = FontWeight.Black, fontSize = 12.sp)
                        }
                    }
                }
            } else {
                // Editing Seller Coordinates & Radius Form
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.SpaceBetween,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text(
                        text = "Edit Seller Coordinates",
                        fontWeight = FontWeight.Black,
                        fontSize = 16.sp,
                        color = FlarePink
                    )
                    
                    Text(
                        text = "Cancel",
                        color = FlarePink,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.clickable { isEditingShop = false }
                    )
                }
                
                Spacer(modifier = Modifier.height(12.dp))
                
                OutlinedTextField(
                    value = shopNameInput,
                    onValueChange = { shopNameInput = it },
                    label = { Text("Store Name") },
                    colors = OutlinedTextFieldDefaults.colors(focusedBorderColor = FlarePink),
                    modifier = Modifier.fillMaxWidth()
                )
                
                Spacer(modifier = Modifier.height(8.dp))
                
                OutlinedTextField(
                    value = shopAddressInput,
                    onValueChange = { shopAddressInput = it },
                    label = { Text("Store Address") },
                    colors = OutlinedTextFieldDefaults.colors(focusedBorderColor = FlarePink),
                    modifier = Modifier.fillMaxWidth()
                )
                
                Spacer(modifier = Modifier.height(8.dp))
                
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    OutlinedTextField(
                        value = shopLatInput,
                        onValueChange = { shopLatInput = it },
                        label = { Text("Latitude") },
                        colors = OutlinedTextFieldDefaults.colors(focusedBorderColor = FlarePink),
                        modifier = Modifier.weight(1f)
                    )
                    
                    OutlinedTextField(
                        value = shopLngInput,
                        onValueChange = { shopLngInput = it },
                        label = { Text("Longitude") },
                        colors = OutlinedTextFieldDefaults.colors(focusedBorderColor = FlarePink),
                        modifier = Modifier.weight(1f)
                    )
                }
                
                Spacer(modifier = Modifier.height(12.dp))
                
                // Slider to adjust Allowed Checkout Radius
                val currentSliderValue = shopRadiusInput.toDoubleOrNull() ?: 10000.0
                Text(
                    text = String.format(Locale.US, "Pickup Checkout Radius Limit: %.1f km", currentSliderValue / 1000.0),
                    fontSize = 12.sp,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onSurface
                )
                
                Slider(
                    value = currentSliderValue.toFloat(),
                    onValueChange = {
                        shopRadiusInput = it.toDouble().toString()
                    },
                    valueRange = 500f..25000f, // 500 meters to 25 km
                    colors = SliderDefaults.colors(
                        thumbColor = FlarePink,
                        activeTrackColor = FlarePink,
                        inactiveTrackColor = MaterialTheme.colorScheme.outline.copy(alpha = 0.2f)
                    )
                )
                
                Spacer(modifier = Modifier.height(12.dp))
                
                Button(
                    onClick = {
                        val lat = shopLatInput.toDoubleOrNull() ?: shopConf.latitude
                        val lng = shopLngInput.toDoubleOrNull() ?: shopConf.longitude
                        val radius = shopRadiusInput.toDoubleOrNull() ?: shopConf.maxCheckoutRadiusMeters
                        viewModel.updateShopCoordinates(shopNameInput, shopAddressInput, lat, lng, radius)
                        isEditingShop = false
                    },
                    colors = ButtonDefaults.buttonColors(containerColor = FlarePink, contentColor = Color.White),
                    shape = RoundedCornerShape(12.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text("Save Store Settings", fontWeight = FontWeight.Bold)
                }
            }
        }
    }
}

@Composable
fun StatusTab(viewModel: ShopViewModel) {
    val ordersList by viewModel.orders.collectAsState()
    
    // Simulate seller packing state locally for absolute precision & interactive joy
    val sellerPackedState = remember { mutableStateMapOf<Int, Boolean>() }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        Text(
            text = "Status Pesanan Anda",
            fontWeight = FontWeight.Black,
            fontSize = 20.sp,
            color = CyberCyan,
            modifier = Modifier.padding(bottom = 4.dp)
        )
        Text(
            text = "Pantau proses packing seller & ambil pesanan Anda secara langsung di lokasi seller.",
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            fontSize = 11.sp,
            modifier = Modifier.padding(bottom = 16.dp)
        )

        val activeOrders = ordersList.filter { it.status == "PENDING_PICKUP" }
        val historyOrders = ordersList.filter { it.status != "PENDING_PICKUP" }

        if (ordersList.isEmpty()) {
            Box(
                contentAlignment = Alignment.Center,
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f)
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center,
                    modifier = Modifier.padding(24.dp)
                ) {
                    Icon(
                        Icons.Default.Store,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.4f),
                        modifier = Modifier.size(72.dp)
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                    Text(
                        text = "Belum Ada Pesanan",
                        fontWeight = FontWeight.Bold,
                        fontSize = 16.sp
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Silakan tambahkan barang dagangan ke keranjang dan penuhi syarat radius checkout untuk membuat pesanan.",
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        fontSize = 12.sp,
                        textAlign = TextAlign.Center,
                        lineHeight = 18.sp
                    )
                }
            }
        } else {
            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(14.dp),
                modifier = Modifier.weight(1f)
            ) {
                if (activeOrders.isNotEmpty()) {
                    item {
                        Text(
                            text = "Pesanan Berjalan",
                            fontWeight = FontWeight.Black,
                            fontSize = 14.sp,
                            color = NeonPurple,
                            modifier = Modifier.padding(bottom = 4.dp)
                        )
                    }
                    
                    items(activeOrders) { order ->
                        val isPacked = sellerPackedState[order.id] ?: false
                        
                        Card(
                            modifier = Modifier
                                .fillMaxWidth()
                                .border(
                                    width = 1.5.dp, 
                                    color = if (isPacked) CyberCyan else NeonPurple, 
                                    shape = RoundedCornerShape(20.dp)
                                ),
                            colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.3f)),
                            shape = RoundedCornerShape(20.dp)
                        ) {
                            Column(modifier = Modifier.padding(16.dp)) {
                                // Order ID and pickup code header
                                Row(
                                    modifier = Modifier.fillMaxWidth(),
                                    horizontalArrangement = Arrangement.SpaceBetween,
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Column {
                                        Text(
                                            text = "Order #${10000 + order.id}",
                                            fontWeight = FontWeight.Bold,
                                            fontSize = 12.sp,
                                            color = MaterialTheme.colorScheme.onSurfaceVariant
                                        )
                                        Text(
                                            text = java.text.SimpleDateFormat("dd MMM yyyy, HH:mm", java.util.Locale.getDefault()).format(java.util.Date(order.timestamp)),
                                            fontSize = 10.sp,
                                            color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.6f)
                                        )
                                    }
                                    
                                    Box(
                                        modifier = Modifier
                                            .background(
                                                color = if (isPacked) CyberCyan.copy(alpha = 0.2f) else NeonPurple.copy(alpha = 0.2f),
                                                shape = RoundedCornerShape(8.dp)
                                            )
                                            .padding(horizontal = 8.dp, vertical = 4.dp)
                                    ) {
                                        Text(
                                            text = if (isPacked) "SIAP DIAMBIL" else "SEDANG DI-PACKING",
                                            color = if (isPacked) CyberCyan else NeonPurple,
                                            fontSize = 10.sp,
                                            fontWeight = FontWeight.Black
                                        )
                                    }
                                }
                                
                                Spacer(modifier = Modifier.height(12.dp))
                                
                                // Progress Steps Tracker
                                Row(
                                    modifier = Modifier.fillMaxWidth(),
                                    horizontalArrangement = Arrangement.SpaceEvenly,
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    // Step 1: Pesanan Dibuat
                                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                        Box(
                                            modifier = Modifier
                                                .size(24.dp)
                                                .background(CyberCyan, CircleShape),
                                            contentAlignment = Alignment.Center
                                        ) {
                                            Icon(Icons.Default.Check, contentDescription = null, tint = Color.Black, modifier = Modifier.size(14.dp))
                                        }
                                        Text("Dibuat", fontSize = 9.sp, fontWeight = FontWeight.Bold, color = CyberCyan, modifier = Modifier.padding(top = 4.dp))
                                    }
                                    
                                    // Divider line 1
                                    Box(modifier = Modifier.weight(1f).height(2.dp).background(if (isPacked) CyberCyan else NeonPurple))
                                    
                                    // Step 2: Proses Packing (Seller)
                                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                        Box(
                                            modifier = Modifier
                                                .size(24.dp)
                                                .background(if (isPacked) CyberCyan else NeonPurple.copy(alpha = 0.3f), CircleShape)
                                                .border(1.dp, NeonPurple, CircleShape),
                                            contentAlignment = Alignment.Center
                                        ) {
                                            if (isPacked) {
                                                Icon(Icons.Default.Check, contentDescription = null, tint = Color.Black, modifier = Modifier.size(14.dp))
                                            } else {
                                                Box(modifier = Modifier.size(6.dp).background(NeonPurple, CircleShape))
                                            }
                                        }
                                        Text("Packing", fontSize = 9.sp, fontWeight = FontWeight.Bold, color = if (isPacked) CyberCyan else NeonPurple, modifier = Modifier.padding(top = 4.dp))
                                    }
                                    
                                    // Divider line 2
                                    Box(modifier = Modifier.weight(1f).height(2.dp).background(if (isPacked) CyberCyan else MaterialTheme.colorScheme.outline.copy(alpha = 0.2f)))
                                    
                                    // Step 3: Siap Dijemput
                                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                        Box(
                                            modifier = Modifier
                                                .size(24.dp)
                                                .background(if (isPacked) CyberCyan.copy(alpha = 0.15f) else Color.Transparent, CircleShape)
                                                .border(1.dp, if (isPacked) CyberCyan else MaterialTheme.colorScheme.outline.copy(alpha = 0.2f), CircleShape),
                                            contentAlignment = Alignment.Center
                                        ) {
                                            if (isPacked) {
                                                Box(modifier = Modifier.size(6.dp).background(CyberCyan, CircleShape))
                                            }
                                        }
                                        Text("Siap Ambil", fontSize = 9.sp, fontWeight = FontWeight.Bold, color = if (isPacked) CyberCyan else MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.5f), modifier = Modifier.padding(top = 4.dp))
                                    }
                                }
                                                      Spacer(modifier = Modifier.height(16.dp))
                                
                                val orderItems by viewModel.getOrderItems(order.id).collectAsState(initial = emptyList())
                                val itemPackedMap = remember { mutableStateMapOf<Int, Boolean>() }
                                val allItemsPacked = orderItems.isNotEmpty() && orderItems.all { itemPackedMap[it.id] == true }

                                Column(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .background(Color.Black.copy(alpha = 0.2f), RoundedCornerShape(12.dp))
                                        .padding(12.dp)
                                ) {
                                    Row(
                                        modifier = Modifier.fillMaxWidth(),
                                        horizontalArrangement = Arrangement.SpaceBetween,
                                        verticalAlignment = Alignment.CenterVertically
                                    ) {
                                        Text(
                                            text = if (!isPacked) "📦 PROSES PACKING SELLER (BELUM SELESAI)" else "📦 DETAIL BARANG TERKEMAS",
                                            fontWeight = FontWeight.Black,
                                            fontSize = 11.sp,
                                            color = if (!isPacked) NeonPurple else CyberCyan
                                        )
                                        if (!isPacked) {
                                            val packedCount = orderItems.count { itemPackedMap[it.id] == true }
                                            Text(
                                                text = "$packedCount/${orderItems.size} Siap",
                                                fontWeight = FontWeight.Bold,
                                                fontSize = 10.sp,
                                                color = if (allItemsPacked) CyberCyan else NeonPurple
                                            )
                                        }
                                    }
                                    Spacer(modifier = Modifier.height(8.dp))
                                    orderItems.forEach { item ->
                                        val isItemPacked = itemPackedMap[item.id] ?: false
                                        Row(
                                            modifier = Modifier
                                                .fillMaxWidth()
                                                .padding(vertical = 4.dp),
                                            horizontalArrangement = Arrangement.SpaceBetween,
                                            verticalAlignment = Alignment.CenterVertically
                                        ) {
                                            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                                Icon(
                                                    imageVector = when (item.productName) {
                                                        "SS Sphere Watch v2" -> Icons.Default.Watch
                                                        "SS Aura Spatial Headphones" -> Icons.Default.Headphones
                                                        "SS Orbit Mechanical Keyboard" -> Icons.Default.Keyboard
                                                        "SS Nebula Tech Backpack" -> Icons.Default.Backpack
                                                        else -> Icons.Default.ShoppingBag
                                                    },
                                                    contentDescription = null,
                                                    tint = if (isItemPacked || isPacked) CyberCyan else MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.6f),
                                                    modifier = Modifier.size(16.dp)
                                                )
                                                Column {
                                                    Text(
                                                        text = item.productName,
                                                        fontSize = 11.sp,
                                                        fontWeight = FontWeight.Bold,
                                                        color = Color.White
                                                    )
                                                    Text(
                                                        text = "${item.quantity}x • ${formatRupiah(item.productPrice)}",
                                                        fontSize = 10.sp,
                                                        color = MaterialTheme.colorScheme.onSurfaceVariant
                                                    )
                                                }
                                            }
                                            
                                            if (!isPacked) {
                                                Button(
                                                    onClick = { itemPackedMap[item.id] = !isItemPacked },
                                                    colors = ButtonDefaults.buttonColors(
                                                        containerColor = if (isItemPacked) CyberCyan.copy(alpha = 0.15f) else NeonPurple.copy(alpha = 0.1f),
                                                        contentColor = if (isItemPacked) CyberCyan else MaterialTheme.colorScheme.onSurfaceVariant
                                                    ),
                                                    contentPadding = PaddingValues(horizontal = 8.dp, vertical = 2.dp),
                                                    shape = RoundedCornerShape(12.dp),
                                                    modifier = Modifier.height(26.dp)
                                                ) {
                                                    Icon(
                                                        imageVector = if (isItemPacked) Icons.Default.Check else Icons.Default.HourglassEmpty,
                                                        contentDescription = null,
                                                        modifier = Modifier.size(12.dp)
                                                    )
                                                    Spacer(modifier = Modifier.width(4.dp))
                                                    Text(if (isItemPacked) "Dalam Box" else "Kemas", fontSize = 9.sp, fontWeight = FontWeight.Black)
                                                }
                                            } else {
                                                Box(
                                                    modifier = Modifier
                                                        .background(CyberCyan.copy(alpha = 0.15f), RoundedCornerShape(8.dp))
                                                        .padding(horizontal = 6.dp, vertical = 2.dp)
                                                ) {
                                                    Text("Sudah Dikemas", color = CyberCyan, fontSize = 9.sp, fontWeight = FontWeight.Black)
                                                }
                                            }
                                        }
                                    }
                                }

                                Spacer(modifier = Modifier.height(10.dp))
                                Text(
                                    text = "Total Pembayaran: ${formatRupiah(order.totalPrice)}",
                                    fontWeight = FontWeight.Black,
                                    fontSize = 13.sp,
                                    color = CyberCyan,
                                    modifier = Modifier.padding(top = 2.dp)
                                )
                                
                                Spacer(modifier = Modifier.height(16.dp))
                                
                                if (!isPacked) {
                                    Card(
                                        colors = CardDefaults.cardColors(
                                            containerColor = if (allItemsPacked) CyberCyan.copy(alpha = 0.1f) else NeonPurple.copy(alpha = 0.1f)
                                        ),
                                        modifier = Modifier.fillMaxWidth()
                                    ) {
                                        Row(
                                            modifier = Modifier.padding(10.dp),
                                            verticalAlignment = Alignment.CenterVertically,
                                            horizontalArrangement = Arrangement.spacedBy(8.dp)
                                        ) {
                                            Icon(
                                                imageVector = if (allItemsPacked) Icons.Default.CheckCircle else Icons.Default.HourglassEmpty,
                                                contentDescription = null,
                                                tint = if (allItemsPacked) CyberCyan else NeonPurple,
                                                modifier = Modifier.size(16.dp)
                                            )
                                            Text(
                                                text = if (allItemsPacked) {
                                                    "Semua barang sudah masuk ke kotak packing! Silakan selesaikan simulasi packing di bawah."
                                                } else {
                                                    "Seller sedang mempersiapkan, memeriksa, dan membungkus pesanan Anda di lokasi toko seller."
                                                },
                                                fontSize = 10.sp,
                                                color = Color.White.copy(alpha = 0.9f),
                                                lineHeight = 14.sp
                                            )
                                        }
                                    }
                                    
                                    Spacer(modifier = Modifier.height(12.dp))
                                    
                                    Button(
                                        onClick = { 
                                            // Auto pack all items and set status
                                            orderItems.forEach { itemPackedMap[it.id] = true }
                                            sellerPackedState[order.id] = true 
                                        },
                                        colors = ButtonDefaults.buttonColors(
                                            containerColor = if (allItemsPacked) CyberCyan else NeonPurple,
                                            contentColor = if (allItemsPacked) Color.Black else Color.White
                                        ),
                                        shape = RoundedCornerShape(12.dp),
                                        modifier = Modifier.fillMaxWidth()
                                    ) {
                                        Icon(Icons.Default.Check, contentDescription = null, modifier = Modifier.size(16.dp))
                                        Spacer(modifier = Modifier.width(6.dp))
                                        Text(
                                            text = if (allItemsPacked) "Selesaikan Packing Sekarang" else "Simulasi Seller: Selesai Packing",
                                            fontWeight = FontWeight.Bold,
                                            fontSize = 11.sp
                                        )
                                    }
                                } else {
                                    // If already packed, show pickup code prominently with neon frame
                                    Box(
                                        modifier = Modifier
                                            .fillMaxWidth()
                                            .background(Color.Black.copy(alpha = 0.4f), RoundedCornerShape(12.dp))
                                            .border(1.dp, CyberCyan.copy(alpha = 0.3f), RoundedCornerShape(12.dp))
                                            .padding(12.dp),
                                        contentAlignment = Alignment.Center
                                    ) {
                                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                            Text("TUNJUKKAN KODE PICKUP INI KEPADA SELLER:", fontSize = 9.sp, color = CyberCyan, fontWeight = FontWeight.Bold)
                                            Text(
                                                text = order.pickupCode,
                                                fontWeight = FontWeight.Black,
                                                fontSize = 24.sp,
                                                color = Color.White,
                                                letterSpacing = 2.sp,
                                                modifier = Modifier.padding(vertical = 4.dp)
                                            )
                                            Text("Lokasi Ambil: ${order.shopName}", fontSize = 10.sp, color = MaterialTheme.colorScheme.onSurfaceVariant, textAlign = TextAlign.Center)
                                        }
                                    }
                                    
                                    Spacer(modifier = Modifier.height(12.dp))
                                    
                                    // Buyer finish pickup confirmation
                                    Button(
                                        onClick = { viewModel.markOrderPickedUp(order.id) },
                                        colors = ButtonDefaults.buttonColors(containerColor = CyberCyan, contentColor = Color.Black),
                                        shape = RoundedCornerShape(12.dp),
                                        modifier = Modifier.fillMaxWidth()
                                    ) {
                                        Icon(Icons.Default.DoneAll, contentDescription = null, modifier = Modifier.size(16.dp))
                                        Spacer(modifier = Modifier.width(6.dp))
                                        Text("Konfirmasi Selesai Ambil (Buyer)", fontWeight = FontWeight.Black, fontSize = 11.sp)
                                    }
                                }
                                
                                Spacer(modifier = Modifier.height(6.dp))
                                
                                // Cancel Order Button
                                TextButton(
                                    onClick = { viewModel.cancelOrder(order.id) },
                                    modifier = Modifier.align(Alignment.CenterHorizontally)
                                ) {
                                    Text("Batalkan Pesanan", color = FlarePink, fontSize = 11.sp, fontWeight = FontWeight.Bold)
                                }
                            }
                        }
                    }
                }
                
                if (historyOrders.isNotEmpty()) {
                    item {
                        Text(
                            text = "Riwayat Pesanan",
                            fontWeight = FontWeight.Black,
                            fontSize = 14.sp,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            modifier = Modifier.padding(top = 10.dp, bottom = 4.dp)
                        )
                    }
                    
                    items(historyOrders) { order ->
                        val isCancelled = order.status == "CANCELLED"
                        Card(
                            modifier = Modifier
                                .fillMaxWidth()
                                .border(width = 1.dp, color = MaterialTheme.colorScheme.outline.copy(alpha = 0.15f), shape = RoundedCornerShape(16.dp)),
                            colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface.copy(alpha = 0.5f)),
                            shape = RoundedCornerShape(16.dp)
                        ) {
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(14.dp),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Column(modifier = Modifier.weight(1f)) {
                                    Text("Order #${10000 + order.id}", fontWeight = FontWeight.Bold, fontSize = 12.sp)
                                    Text("Status: ${if (isCancelled) "Batal" else "Sudah Diambil"}", fontSize = 10.sp, color = if (isCancelled) FlarePink else CyberCyan)
                                    Text("Total: ${formatRupiah(order.totalPrice)}", fontSize = 11.sp, fontWeight = FontWeight.SemiBold, modifier = Modifier.padding(top = 2.dp))
                                }
                                
                                Box(
                                    modifier = Modifier
                                        .background(
                                            color = if (isCancelled) FlarePink.copy(alpha = 0.15f) else CyberCyan.copy(alpha = 0.15f),
                                            shape = RoundedCornerShape(6.dp)
                                        )
                                        .padding(horizontal = 8.dp, vertical = 4.dp)
                                ) {
                                    Text(
                                        text = if (isCancelled) "CANCELLED" else "COMPLETED",
                                        color = if (isCancelled) FlarePink else CyberCyan,
                                        fontSize = 9.sp,
                                        fontWeight = FontWeight.Bold
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun SettingTab(viewModel: ShopViewModel, onLocationPermissionRequest: () -> Unit) {
    val buyerLat by viewModel.buyerLatitude.collectAsState()
    val buyerLng by viewModel.buyerLongitude.collectAsState()
    val isUsingGpsVal by viewModel.isUsingGps.collectAsState()
    val reviewsList by viewModel.reviews.collectAsState(initial = emptyList())
    
    var raterNameInput by remember { mutableStateOf("Sphere Buyer Elite") }
    var reviewText by remember { mutableStateOf("") }
    var selectedStars by remember { mutableStateOf(5) }

    LazyColumn(
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        modifier = Modifier.fillMaxSize()
    ) {
        // HEADER 1: App Requirements & Permissions (Kebutuhan Aplikasi & Perizinan)
        item {
            Column {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Icon(
                        imageVector = Icons.Default.Settings,
                        contentDescription = null,
                        tint = CyberCyan,
                        modifier = Modifier.size(20.dp)
                    )
                    Text(
                        text = "Kebutuhan Aplikasi & Perizinan",
                        fontWeight = FontWeight.Black,
                        fontSize = 18.sp,
                        color = Color.White
                    )
                }
                Text(
                    text = "Aplikasi ini memerlukan perizinan GPS hardware untuk menghitung radius checkout real-time ke toko seller.",
                    fontSize = 11.5.sp,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(top = 4.dp, bottom = 4.dp)
                )
            }
        }

        // Section 1 Card: Status Lokasi & Izin GPS (Kebutuhan Aplikasi)
        item {
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.3f)),
                shape = RoundedCornerShape(20.dp),
                border = BorderStroke(1.dp, CyberCyan.copy(alpha = 0.15f))
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        Icon(Icons.Default.MyLocation, contentDescription = null, tint = CyberCyan)
                        Text(
                            text = "Konfigurasi & Status Sensor",
                            fontWeight = FontWeight.Bold,
                            fontSize = 14.sp,
                            color = Color.White
                        )
                    }
                    
                    Spacer(modifier = Modifier.height(12.dp))
                    
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text("Metode Deteksi:", fontSize = 11.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                        Text(
                            text = if (isUsingGpsVal) "GPS Hardware Terbuka" else "Simulasi Titik Lokasi",
                            fontWeight = FontWeight.Black,
                            fontSize = 11.sp,
                            color = if (isUsingGpsVal) CyberCyan else NeonPurple
                        )
                    }
                    Spacer(modifier = Modifier.height(6.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text("Latitude Pembeli:", fontSize = 11.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                        Text(
                            text = String.format(Locale.US, "%.6f", buyerLat),
                            fontSize = 11.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.White
                        )
                    }
                    Spacer(modifier = Modifier.height(6.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text("Longitude Pembeli:", fontSize = 11.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                        Text(
                            text = String.format(Locale.US, "%.6f", buyerLng),
                            fontSize = 11.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.White
                        )
                    }

                    Spacer(modifier = Modifier.height(14.dp))

                    Button(
                        onClick = onLocationPermissionRequest,
                        colors = ButtonDefaults.buttonColors(containerColor = CyberCyan, contentColor = Color.Black),
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Icon(Icons.Default.Lock, contentDescription = null, modifier = Modifier.size(16.dp))
                        Spacer(modifier = Modifier.width(6.dp))
                        Text("Aktifkan / Minta Izin GPS Android", fontWeight = FontWeight.Black, fontSize = 11.sp)
                    }
                }
            }
        }

        // HEADER 2: Account & Reviews Section (Akun & Ulasan Seller)
        item {
            Column(modifier = Modifier.padding(top = 8.dp)) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Icon(
                        imageVector = Icons.Default.Person,
                        contentDescription = null,
                        tint = NeonPurple,
                        modifier = Modifier.size(20.dp)
                    )
                    Text(
                        text = "Profil Akun & Ulasan Seller",
                        fontWeight = FontWeight.Black,
                        fontSize = 18.sp,
                        color = Color.White
                    )
                }
                Text(
                    text = "Gunakan ulasan dari akun terverifikasi Anda untuk memberikan penilaian objektif terhadap pelayanan seller.",
                    fontSize = 11.5.sp,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(top = 4.dp, bottom = 4.dp)
                )
            }
        }

        // Section 2 Card: Profil & Informasi Akun
        item {
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.3f)),
                shape = RoundedCornerShape(20.dp),
                border = BorderStroke(1.dp, NeonPurple.copy(alpha = 0.15f))
            ) {
                Row(
                    modifier = Modifier.padding(16.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    Box(
                        modifier = Modifier
                            .size(54.dp)
                            .background(
                                Brush.linearGradient(colors = listOf(CyberCyan, NeonPurple)),
                                CircleShape
                            ),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(Icons.Default.Person, contentDescription = null, tint = Color.Black, modifier = Modifier.size(28.dp))
                    }
                    
                    Column {
                        Text(
                            text = raterNameInput,
                            fontWeight = FontWeight.Black,
                            fontSize = 16.sp,
                            color = Color.White
                        )
                        Text(
                            text = "buyer@shopsphere.co • Member VIP",
                            fontSize = 11.sp,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                        Box(
                            modifier = Modifier
                                .padding(top = 4.dp)
                                .background(CyberCyan.copy(alpha = 0.15f), RoundedCornerShape(6.dp))
                                .padding(horizontal = 6.dp, vertical = 2.dp)
                        ) {
                            Text("RADIUS CHECKOUT AKTIF", color = CyberCyan, fontSize = 9.sp, fontWeight = FontWeight.Bold)
                        }
                    }
                }
            }
        }

        // Section 3 Card: Kirim Ulasan Terhadap Seller dari Akun ini
        item {
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.3f)),
                shape = RoundedCornerShape(20.dp),
                border = BorderStroke(1.dp, CyberCyan.copy(alpha = 0.15f))
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        Icon(Icons.Default.Star, contentDescription = null, tint = CyberCyan)
                        Text(
                            text = "Kirim Ulasan dari Akun Anda",
                            fontWeight = FontWeight.Bold,
                            fontSize = 14.sp,
                            color = Color.White
                        )
                    }
                    
                    Text(
                        text = "Beri feedback kualitas pelayanan dan keakuratan titik lokasi toko fisik seller.",
                        fontSize = 11.sp,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.padding(top = 2.dp, bottom = 12.dp)
                    )

                    // Stars Selector Input
                    Row(
                        horizontalArrangement = Arrangement.spacedBy(6.dp),
                        modifier = Modifier.fillMaxWidth(),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("Rating Bintang:", fontSize = 11.5.sp, fontWeight = FontWeight.Bold)
                        Row {
                            for (i in 1..5) {
                                IconButton(
                                    onClick = { selectedStars = i },
                                    modifier = Modifier.size(32.dp)
                                ) {
                                    Icon(
                                        imageVector = if (i <= selectedStars) Icons.Default.Star else Icons.Default.StarBorder,
                                        contentDescription = null,
                                        tint = if (i <= selectedStars) CyberCyan else MaterialTheme.colorScheme.outline
                                    )
                                }
                            }
                        }
                    }

                    Spacer(modifier = Modifier.height(10.dp))

                    // Review Comments Text Field
                    OutlinedTextField(
                        value = reviewText,
                        onValueChange = { reviewText = it },
                        placeholder = { Text("Tulis ulasan Anda secara detail terhadap seller...", fontSize = 12.sp, color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.6f)) },
                        modifier = Modifier.fillMaxWidth(),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = CyberCyan,
                            unfocusedBorderColor = MaterialTheme.colorScheme.outline.copy(alpha = 0.2f),
                            focusedContainerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.15f),
                            unfocusedContainerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.15f)
                        ),
                        shape = RoundedCornerShape(12.dp)
                    )

                    Spacer(modifier = Modifier.height(14.dp))

                    // Submit review button
                    Button(
                        onClick = {
                            if (reviewText.isNotBlank()) {
                                viewModel.addReview(raterNameInput, selectedStars, reviewText)
                                reviewText = ""
                            }
                        },
                        enabled = reviewText.isNotBlank(),
                        colors = ButtonDefaults.buttonColors(
                            containerColor = CyberCyan,
                            contentColor = Color.Black,
                            disabledContainerColor = MaterialTheme.colorScheme.surfaceVariant,
                            disabledContentColor = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.4f)
                        ),
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Icon(Icons.Default.Send, contentDescription = null, modifier = Modifier.size(16.dp))
                        Spacer(modifier = Modifier.width(6.dp))
                        Text("Kirim Ulasan Akun", fontWeight = FontWeight.Black, fontSize = 11.sp)
                    }
                }
            }
        }

        // Section 4: Daftar Semua Ulasan Seller
        item {
            Text(
                text = "Daftar Ulasan Pelanggan Terhadap Seller (${reviewsList.size})",
                fontWeight = FontWeight.Black,
                fontSize = 14.sp,
                color = CyberCyan,
                modifier = Modifier.padding(top = 8.dp)
            )
        }

        if (reviewsList.isEmpty()) {
            item {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(24.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text("Belum ada ulasan yang masuk.", fontSize = 11.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
            }
        } else {
            items(reviewsList) { review ->
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.15f)),
                    shape = RoundedCornerShape(14.dp)
                ) {
                    Column(modifier = Modifier.padding(12.dp)) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                Icon(
                                    imageVector = Icons.Default.Person,
                                    contentDescription = null,
                                    tint = CyberCyan,
                                    modifier = Modifier.size(14.dp)
                                )
                                Text(
                                    text = review.raterName.ifBlank { "Anonim" },
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 12.sp,
                                    color = Color.White
                                )
                            }
                            
                            // Star Rating indicators
                            Row(horizontalArrangement = Arrangement.spacedBy(2.dp)) {
                                for (i in 1..5) {
                                    Icon(
                                        imageVector = Icons.Default.Star,
                                        contentDescription = null,
                                        tint = if (i <= review.rating) CyberCyan else MaterialTheme.colorScheme.outline.copy(alpha = 0.2f),
                                        modifier = Modifier.size(12.dp)
                                    )
                                }
                            }
                        }
                        
                        Text(
                            text = review.comment,
                            fontSize = 11.sp,
                            color = MaterialTheme.colorScheme.onSurface,
                            modifier = Modifier.padding(top = 6.dp),
                            lineHeight = 15.sp
                        )
                        
                        Text(
                            text = "Diposkan pada: " + java.text.SimpleDateFormat("dd MMM yyyy, HH:mm", java.util.Locale.getDefault()).format(java.util.Date(review.timestamp)),
                            fontSize = 9.sp,
                            color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.5f),
                            modifier = Modifier.padding(top = 8.dp)
                        )
                    }
                }
            }
        }
    }
}
