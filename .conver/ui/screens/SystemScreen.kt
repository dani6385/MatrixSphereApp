package com.example.ui.screens

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
import com.example.ui.theme.TealTertiary
import com.example.ui.viewmodel.AppViewModel

@Composable
fun SystemScreen(
    viewModel: AppViewModel,
    modifier: Modifier = Modifier
) {
    val sellers by viewModel.sellers.collectAsState()
    val bannedSellers = remember(sellers) {
        sellers.filter { it.isBanned }
    }

    // Access management list simulation
    var systemUsers by remember {
        mutableStateOf(
            listOf(
                SystemUser("admin", "Administrator Utama", "Super Admin", "Aktif"),
                SystemUser("sec_moderator", "SecurApp Moderator", "Moderator", "Aktif"),
                SystemUser("support_it", "Support & IT Helpdesk", "Operator", "Aktif"),
                SystemUser("guest_temp", "Tamu Sementara", "Viewer", "Nonaktif")
            )
        )
    }

    var selectedUserToEdit by remember { mutableStateOf<SystemUser?>(null) }

    LazyColumn(
        modifier = modifier
            .fillMaxSize()
            .padding(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        contentPadding = PaddingValues(top = 12.dp, bottom = 24.dp)
    ) {
        // Section title: User Access Management
        item {
            Column {
                Text(
                    text = "Manajemen Akses Pengguna",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onBackground
                )
                Text(
                    text = "Konfigurasi tingkat keamanan dan hak akses untuk admin/staf",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }

        items(systemUsers, key = { it.username }) { user ->
            SystemUserRowItem(
                user = user,
                onRoleChange = { newRole ->
                    systemUsers = systemUsers.map {
                        if (it.username == user.username) it.copy(role = newRole) else it
                    }
                },
                onStatusToggle = {
                    systemUsers = systemUsers.map {
                        if (it.username == user.username) {
                            val nextStatus = if (it.status == "Aktif") "Nonaktif" else "Aktif"
                            it.copy(status = nextStatus)
                        } else it
                    }
                }
            )
        }

        // Section title: Banned Compliance List
        item {
            Column(modifier = Modifier.padding(top = 12.dp)) {
                Text(
                    text = "Daftar Banned & Kepatuhan",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.error
                )
                Text(
                    text = "Sanksi pelanggaran aktif untuk menjamin keamanan platform",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }

        if (bannedSellers.isEmpty()) {
            item {
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
                    border = BorderStroke(1.dp, MaterialTheme.colorScheme.surfaceVariant)
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(20.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        Icon(
                            Icons.Default.VerifiedUser,
                            contentDescription = "Safe",
                            tint = TealTertiary,
                            modifier = Modifier.size(24.dp)
                        )
                        Column {
                            Text(
                                "Platform Sepenuhnya Patuh",
                                style = MaterialTheme.typography.titleSmall,
                                fontWeight = FontWeight.Bold
                            )
                            Text(
                                "Tidak ada akun seller yang sedang dibanned.",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }
                }
            }
        } else {
            items(bannedSellers, key = { it.id }) { seller ->
                BannedSellerRowItem(
                    sellerName = seller.name,
                    storeName = seller.storeName,
                    reason = seller.banReason ?: "Pelanggaran tidak ditentukan",
                    onRestoreClick = { viewModel.unbanSeller(seller.id) }
                )
            }
        }

        // System Configuration Overview
        item {
            Column(modifier = Modifier.padding(top = 12.dp)) {
                Text(
                    text = "Parameter Keamanan Sistem",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onBackground
                )
                Text(
                    text = "Konfigurasi audit internal",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }

        item {
            SystemSecurityConfigCard()
        }
    }
}

data class SystemUser(
    val username: String,
    val fullName: String,
    val role: String, // Super Admin, Moderator, Operator, Viewer
    val status: String // Aktif, Nonaktif
)

@OptIn(ExperimentalLayoutApi::class)
@Composable
fun SystemUserRowItem(
    user: SystemUser,
    onRoleChange: (String) -> Unit,
    onStatusToggle: () -> Unit
) {
    var showRoleDropdown by remember { mutableStateOf(false) }
    val roles = listOf("Super Admin", "Moderator", "Operator", "Viewer")

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .shadow(0.5.dp, RoundedCornerShape(12.dp)),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.surfaceVariant)
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
                // User icon placeholder
                Box(
                    modifier = Modifier
                        .size(36.dp)
                        .background(MaterialTheme.colorScheme.primary.copy(alpha = 0.15f), CircleShape),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        Icons.Default.Security,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.size(18.dp)
                    )
                }
                Spacer(modifier = Modifier.width(12.dp))
                Column(modifier = Modifier.weight(1.0f)) {
                    Text(
                        text = user.fullName,
                        style = MaterialTheme.typography.titleSmall,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.onSurface
                    )
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(6.dp)
                    ) {
                        Text(
                            text = "@${user.username}",
                            fontSize = 11.sp,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                        Box {
                            Text(
                                text = "•  ${user.role}",
                                fontSize = 11.sp,
                                fontWeight = FontWeight.Bold,
                                color = MaterialTheme.colorScheme.primary,
                                modifier = Modifier.testTag("user_role_label_${user.username}").clickable { showRoleDropdown = true }
                            )
                            DropdownMenu(
                                expanded = showRoleDropdown,
                                onDismissRequest = { showRoleDropdown = false }
                            ) {
                                roles.forEach { r ->
                                    DropdownMenuItem(
                                        text = { Text(r) },
                                        onClick = {
                                            onRoleChange(r)
                                            showRoleDropdown = false
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.width(12.dp))

            // Status Badge switch
            Column(horizontalAlignment = Alignment.End) {
                TextButton(
                    onClick = onStatusToggle,
                    colors = ButtonDefaults.textButtonColors(
                        contentColor = if (user.status == "Aktif") TealTertiary else MaterialTheme.colorScheme.error
                    ),
                    contentPadding = PaddingValues(horizontal = 12.dp, vertical = 4.dp),
                    modifier = Modifier.testTag("user_status_button_${user.username}")
                ) {
                    Icon(
                        imageVector = if (user.status == "Aktif") Icons.Default.CheckCircle else Icons.Default.PowerSettingsNew,
                        contentDescription = null,
                        modifier = Modifier.size(14.dp)
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(
                        text = user.status.uppercase(),
                        fontSize = 10.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }
        }
    }
}

@Composable
fun BannedSellerRowItem(
    sellerName: String,
    storeName: String,
    reason: String,
    onRestoreClick: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .shadow(1.dp, RoundedCornerShape(12.dp)),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.errorContainer.copy(alpha = 0.05f)),
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.error.copy(alpha = 0.2f))
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(12.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(
                        Icons.Default.Warning,
                        contentDescription = "Banned Icon",
                        tint = MaterialTheme.colorScheme.error,
                        modifier = Modifier.size(16.dp)
                    )
                    Spacer(modifier = Modifier.width(6.dp))
                    Text(
                        text = storeName,
                        style = MaterialTheme.typography.titleSmall,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.error
                    )
                }
                Spacer(modifier = Modifier.height(2.dp))
                Text(
                    text = "Seller: $sellerName",
                    style = MaterialTheme.typography.bodySmall,
                    fontSize = 11.sp,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Spacer(modifier = Modifier.height(6.dp))
                Text(
                    text = "Pelanggaran: $reason",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurface,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis
                )
            }

            Spacer(modifier = Modifier.width(12.dp))

            Button(
                onClick = onRestoreClick,
                colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.error),
                contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp),
                shape = RoundedCornerShape(8.dp),
                modifier = Modifier.testTag("restore_seller_button_$storeName")
            ) {
                Text("Pulihkan", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = Color.White)
            }
        }
    }
}

@Composable
fun SystemSecurityConfigCard() {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .shadow(1.dp, RoundedCornerShape(16.dp)),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.surfaceVariant)
    ) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column {
                    Text("Auto-Ban Pelanggaran Berat", style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
                    Text("Deteksi bot & spamming otomatis ditangguhkan", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
                var checked1 by remember { mutableStateOf(true) }
                Switch(checked = checked1, onCheckedChange = { checked1 = it })
            }

            HorizontalDivider(color = MaterialTheme.colorScheme.surfaceVariant, thickness = 0.5.dp)

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column {
                    Text("Audit Log Enkripsi SHA-256", style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
                    Text("Simpan riwayat perubahan database dienkripsi", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
                var checked2 by remember { mutableStateOf(true) }
                Switch(checked = checked2, onCheckedChange = { checked2 = it })
            }

            HorizontalDivider(color = MaterialTheme.colorScheme.surfaceVariant, thickness = 0.5.dp)

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column {
                    Text("Akses Multi-Device Terbatas", style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
                    Text("Batasi login admin hanya 1 perangkat aktif", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
                var checked3 by remember { mutableStateOf(false) }
                Switch(checked = checked3, onCheckedChange = { checked3 = it })
            }
        }
    }
}
