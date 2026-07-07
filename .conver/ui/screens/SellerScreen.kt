package com.example.ui.screens

import androidx.compose.animation.*
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
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
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.model.Seller
import com.example.ui.theme.TealTertiary
import com.example.ui.viewmodel.AppViewModel

@Composable
fun SellerScreen(
    viewModel: AppViewModel,
    modifier: Modifier = Modifier
) {
    val sellers by viewModel.sellers.collectAsState()
    val searchQuery by viewModel.sellerSearchQuery.collectAsState()
    val filterStatus by viewModel.sellerFilterStatus.collectAsState()

    var showAddSellerDialog by remember { mutableStateOf(false) }
    var sellerToBan by remember { mutableStateOf<Seller?>(null) }

    // Filter and search computation
    val filteredSellers = remember(sellers, searchQuery, filterStatus) {
        sellers.filter { seller ->
            val matchQuery = seller.name.contains(searchQuery, ignoreCase = true) ||
                    seller.storeName.contains(searchQuery, ignoreCase = true) ||
                    seller.email.contains(searchQuery, ignoreCase = true)

            val matchStatus = when (filterStatus) {
                "Aktif" -> seller.status == "Aktif" && !seller.isBanned
                "Tidak Aktif" -> seller.status == "Tidak Aktif" && !seller.isBanned
                "Banned" -> seller.isBanned
                else -> true // "Semua"
            }

            matchQuery && matchStatus
        }
    }

    Column(
        modifier = modifier
            .fillMaxSize()
            .padding(horizontal = 16.dp)
    ) {
        // Search and Add Header Row
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 12.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            OutlinedTextField(
                value = searchQuery,
                onValueChange = { viewModel.setSellerSearchQuery(it) },
                placeholder = { Text("Cari nama, toko, atau email...") },
                leadingIcon = { Icon(Icons.Default.Search, contentDescription = "Search Icon") },
                singleLine = true,
                shape = RoundedCornerShape(12.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedBorderColor = MaterialTheme.colorScheme.primary,
                    unfocusedBorderColor = MaterialTheme.colorScheme.surfaceVariant
                ),
                modifier = Modifier
                    .weight(1f)
                    .testTag("seller_search_input")
            )

            FloatingActionButton(
                onClick = { showAddSellerDialog = true },
                containerColor = MaterialTheme.colorScheme.primary,
                contentColor = MaterialTheme.colorScheme.onPrimary,
                shape = RoundedCornerShape(12.dp),
                modifier = Modifier
                    .size(56.dp)
                    .testTag("add_seller_fab")
            ) {
                Icon(Icons.Default.PersonAdd, contentDescription = "Daftarkan Seller")
            }
        }

        // Filter chips list
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 8.dp),
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            val filters = listOf("Semua", "Aktif", "Tidak Aktif", "Banned")
            filters.forEach { status ->
                val selected = filterStatus == status
                FilterChip(
                    selected = selected,
                    onClick = { viewModel.setSellerFilterStatus(status) },
                    label = { Text(status) },
                    colors = FilterChipDefaults.filterChipColors(
                        selectedContainerColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.15f),
                        selectedLabelColor = MaterialTheme.colorScheme.primary,
                        selectedLeadingIconColor = MaterialTheme.colorScheme.primary
                    ),
                    modifier = Modifier.testTag("filter_chip_$status")
                )
            }
        }

        // Sellers count indicator
        Text(
            text = "Ditemukan ${filteredSellers.size} Penjual",
            style = MaterialTheme.typography.bodySmall,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.padding(bottom = 12.dp)
        )

        // Sellers List
        if (filteredSellers.isEmpty()) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f),
                contentAlignment = Alignment.Center
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Icon(
                        Icons.Default.PeopleOutline,
                        contentDescription = "Empty",
                        tint = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.size(64.dp)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Tidak ada penjual yang cocok",
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        style = MaterialTheme.typography.bodyMedium
                    )
                }
            }
        } else {
            LazyColumn(
                modifier = Modifier.weight(1f),
                verticalArrangement = Arrangement.spacedBy(12.dp),
                contentPadding = PaddingValues(bottom = 24.dp)
            ) {
                items(filteredSellers, key = { it.id }) { seller ->
                    SellerRowItem(
                        seller = seller,
                        onBanClick = { sellerToBan = seller },
                        onUnbanClick = { viewModel.unbanSeller(seller.id) },
                        onDeleteClick = { viewModel.deleteSeller(seller.id) }
                    )
                }
            }
        }
    }

    if (showAddSellerDialog) {
        AddSellerDialog(
            onDismiss = { showAddSellerDialog = false },
            onConfirm = { name, store, email, phone ->
                viewModel.addNewSeller(name, store, email, phone)
                showAddSellerDialog = false
            }
        )
    }

    if (sellerToBan != null) {
        BanReasonDialog(
            seller = sellerToBan!!,
            onDismiss = { sellerToBan = null },
            onConfirm = { reason ->
                viewModel.banSeller(sellerToBan!!.id, reason)
                sellerToBan = null
            }
        )
    }
}

@Composable
fun SellerRowItem(
    seller: Seller,
    onBanClick: () -> Unit,
    onUnbanClick: () -> Unit,
    onDeleteClick: () -> Unit
) {
    var expandedMenu by remember { mutableStateOf(false) }

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .shadow(1.dp, RoundedCornerShape(16.dp)),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(
            containerColor = if (seller.isBanned) {
                MaterialTheme.colorScheme.errorContainer.copy(alpha = 0.1f)
            } else {
                MaterialTheme.colorScheme.surface
            }
        ),
        border = BorderStroke(
            width = 1.dp,
            color = if (seller.isBanned) {
                MaterialTheme.colorScheme.error.copy(alpha = 0.3f)
            } else {
                MaterialTheme.colorScheme.surfaceVariant
            }
        )
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.Top,
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.weight(1f)
                ) {
                    // Profile Icon placeholder with dynamic alphabet
                    Box(
                        modifier = Modifier
                            .size(48.dp)
                            .background(
                                color = if (seller.isBanned) {
                                    MaterialTheme.colorScheme.error.copy(alpha = 0.2f)
                                } else if (seller.status == "Aktif") {
                                    TealTertiary.copy(alpha = 0.15f)
                                } else {
                                    MaterialTheme.colorScheme.surfaceVariant
                                },
                                shape = CircleShape
                            ),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = seller.name.take(1).uppercase(),
                            style = MaterialTheme.typography.titleMedium,
                            fontWeight = FontWeight.Bold,
                            color = if (seller.isBanned) {
                                MaterialTheme.colorScheme.error
                            } else if (seller.status == "Aktif") {
                                TealTertiary
                            } else {
                                MaterialTheme.colorScheme.onSurfaceVariant
                            }
                        )
                    }
                    Spacer(modifier = Modifier.width(16.dp))
                    Column {
                        Text(
                            text = seller.name,
                            style = MaterialTheme.typography.titleSmall,
                            fontWeight = FontWeight.Bold,
                            color = MaterialTheme.colorScheme.onSurface
                        )
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(
                                Icons.Default.Storefront,
                                contentDescription = "Toko",
                                tint = MaterialTheme.colorScheme.primary,
                                modifier = Modifier.size(14.dp)
                            )
                            Spacer(modifier = Modifier.width(4.dp))
                            Text(
                                text = seller.storeName,
                                style = MaterialTheme.typography.bodySmall,
                                fontWeight = FontWeight.Bold,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }
                }

                // Action Menu Dropdown
                Box {
                    IconButton(onClick = { expandedMenu = !expandedMenu }) {
                        Icon(Icons.Default.MoreVert, contentDescription = "Menu Aksi")
                    }
                    DropdownMenu(
                        expanded = expandedMenu,
                        onDismissRequest = { expandedMenu = false }
                    ) {
                        if (seller.isBanned) {
                            DropdownMenuItem(
                                text = { Text("Unban Seller") },
                                leadingIcon = { Icon(Icons.Default.CheckCircle, contentDescription = "Unban", tint = TealTertiary) },
                                onClick = {
                                    onUnbanClick()
                                    expandedMenu = false
                                }
                            )
                        } else {
                            DropdownMenuItem(
                                text = { Text("Ban Seller", color = MaterialTheme.colorScheme.error) },
                                leadingIcon = { Icon(Icons.Default.Block, contentDescription = "Ban", tint = MaterialTheme.colorScheme.error) },
                                onClick = {
                                    onBanClick()
                                    expandedMenu = false
                                }
                            )
                        }
                        DropdownMenuItem(
                            text = { Text("Hapus Permanen", color = MaterialTheme.colorScheme.error) },
                            leadingIcon = { Icon(Icons.Default.Delete, contentDescription = "Hapus", tint = MaterialTheme.colorScheme.error) },
                            onClick = {
                                onDeleteClick()
                                expandedMenu = false
                            }
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Extra Info Grid
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(Icons.Default.Email, contentDescription = "Email", tint = MaterialTheme.colorScheme.onSurfaceVariant, modifier = Modifier.size(12.dp))
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(seller.email, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                    }
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(Icons.Default.Phone, contentDescription = "Telepon", tint = MaterialTheme.colorScheme.onSurfaceVariant, modifier = Modifier.size(12.dp))
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(seller.contact, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                    }
                }

                // Status Tag Badge
                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(8.dp))
                        .background(
                            color = if (seller.isBanned) {
                                MaterialTheme.colorScheme.error.copy(alpha = 0.2f)
                            } else if (seller.status == "Aktif") {
                                TealTertiary.copy(alpha = 0.2f)
                            } else {
                                MaterialTheme.colorScheme.surfaceVariant
                            }
                        )
                        .padding(horizontal = 10.dp, vertical = 6.dp)
                ) {
                    Text(
                        text = if (seller.isBanned) "BANNED" else seller.status.uppercase(),
                        style = MaterialTheme.typography.labelSmall,
                        fontWeight = FontWeight.Bold,
                        color = if (seller.isBanned) {
                            MaterialTheme.colorScheme.error
                        } else if (seller.status == "Aktif") {
                            TealTertiary
                        } else {
                            MaterialTheme.colorScheme.onSurfaceVariant
                        }
                    )
                }
            }

            // Reason for banned (if exists)
            if (seller.isBanned && seller.banReason != null) {
                Spacer(modifier = Modifier.height(8.dp))
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(
                            MaterialTheme.colorScheme.error.copy(alpha = 0.05f),
                            RoundedCornerShape(8.dp)
                        )
                        .padding(10.dp)
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(
                            Icons.Default.Warning,
                            contentDescription = "Warning",
                            tint = MaterialTheme.colorScheme.error,
                            modifier = Modifier.size(14.dp)
                        )
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(
                            text = "Alasan: ${seller.banReason}",
                            style = MaterialTheme.typography.bodySmall,
                            fontSize = 11.sp,
                            color = MaterialTheme.colorScheme.error,
                            maxLines = 2,
                            overflow = TextOverflow.Ellipsis
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun AddSellerDialog(
    onDismiss: () -> Unit,
    onConfirm: (String, String, String, String) -> Unit
) {
    var name by remember { mutableStateOf("") }
    var storeName by remember { mutableStateOf("") }
    var email by remember { mutableStateOf("") }
    var phone by remember { mutableStateOf("") }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = {
            Text("Daftarkan Seller Baru", fontWeight = FontWeight.Bold)
        },
        text = {
            Column(
                verticalArrangement = Arrangement.spacedBy(12.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text("Nama Lengkap") },
                    placeholder = { Text("Contoh: Rudi Hermawan") },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth().testTag("seller_name_input")
                )

                OutlinedTextField(
                    value = storeName,
                    onValueChange = { storeName = it },
                    label = { Text("Nama Toko") },
                    placeholder = { Text("Contoh: Jaya Cellular") },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth().testTag("seller_store_input")
                )

                OutlinedTextField(
                    value = email,
                    onValueChange = { email = it },
                    label = { Text("Email") },
                    placeholder = { Text("Contoh: rudi.hermawan@gmail.com") },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth().testTag("seller_email_input")
                )

                OutlinedTextField(
                    value = phone,
                    onValueChange = { phone = it },
                    label = { Text("Nomor Telepon / WhatsApp") },
                    placeholder = { Text("Contoh: 0812345678") },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth().testTag("seller_phone_input")
                )
            }
        },
        confirmButton = {
            Button(
                onClick = {
                    if (name.isNotBlank() && storeName.isNotBlank() && email.isNotBlank()) {
                        onConfirm(name, storeName, email, phone)
                    }
                },
                enabled = name.isNotBlank() && storeName.isNotBlank() && email.isNotBlank()
            ) {
                Text("Daftarkan")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text("Batal")
            }
        }
    )
}

@Composable
fun BanReasonDialog(
    seller: Seller,
    onDismiss: () -> Unit,
    onConfirm: (String) -> Unit
) {
    var reason by remember { mutableStateOf("") }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = {
            Text("Tangguhkan Seller", fontWeight = FontWeight.Bold)
        },
        text = {
            Column(modifier = Modifier.fillMaxWidth()) {
                Text(
                    text = "Konfirmasi pemblokiran toko '${seller.storeName}' oleh seller '${seller.name}'. Berikan alasan pemblokiran agar dicatat sistem.",
                    style = MaterialTheme.typography.bodyMedium,
                    modifier = Modifier.padding(bottom = 12.dp)
                )

                OutlinedTextField(
                    value = reason,
                    onValueChange = { reason = it },
                    label = { Text("Alasan Pelanggaran") },
                    placeholder = { Text("Contoh: Penipuan transaksi barang tiruan...") },
                    modifier = Modifier.fillMaxWidth().testTag("ban_reason_input")
                )
            }
        },
        confirmButton = {
            Button(
                onClick = {
                    if (reason.isNotBlank()) {
                        onConfirm(reason)
                    }
                },
                colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.error),
                enabled = reason.isNotBlank()
            ) {
                Text("Tangguhkan")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text("Batal")
            }
        }
    )
}
