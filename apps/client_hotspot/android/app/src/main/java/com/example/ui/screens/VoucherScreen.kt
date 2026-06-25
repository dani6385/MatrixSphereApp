package com.example.ui.screens

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.widget.Toast
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ClearAll
import androidx.compose.material.icons.filled.ContentCopy
import androidx.compose.material.icons.filled.FilterList
import androidx.compose.material.icons.filled.LocalActivity
import androidx.compose.material.icons.filled.QrCode2
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import com.example.data.Voucher
import com.example.ui.HotspotViewModel

@Composable
fun VoucherScreen(viewModel: HotspotViewModel, modifier: Modifier = Modifier) {
    val context = LocalContext.current
    val vouchers by viewModel.vouchers.collectAsState()

    var searchQuery by remember { mutableStateOf("") }
    var filterType by remember { mutableStateOf("SEMUA") } // SEMUA, BELUM TERPAKAI, TERPAKAI

    var showGenerateDialog by remember { mutableStateOf(false) }
    var selectedVoucherForPrint by remember { mutableStateOf<Voucher?>(null) }

    val filteredVouchers = vouchers.filter {
        val matchesSearch = it.code.contains(searchQuery, ignoreCase = true) ||
                it.packageName.contains(searchQuery, ignoreCase = true)
        val matchesFilter = when (filterType) {
            "BELUM TERPAKAI" -> !it.isUsed
            "TERPAKAI" -> it.isUsed
            else -> true
        }
        matchesSearch && matchesFilter
    }

    LazyColumn(
        modifier = modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .padding(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
            Spacer(modifier = Modifier.height(16.dp))
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column {
                    Text(
                        text = "MANAJEMEN VOUCHER",
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF1E293B)
                    )
                    Text(
                        text = "Buat, cari, dan kelola voucher hotspot pelanggan.",
                        fontSize = 12.sp,
                        color = Color(0xFF64748B)
                    )
                }

                Row {
                    // Clear all
                    IconButton(
                        onClick = {
                            viewModel.clearAllVouchers()
                            Toast.makeText(context, "Semua voucher dihapus", Toast.LENGTH_SHORT).show()
                        },
                        modifier = Modifier
                            .size(36.dp)
                            .background(Color(0xFFFEE2E2), CircleShape)
                    ) {
                        Icon(Icons.Default.ClearAll, "Clear", tint = Color(0xFF991B1B), modifier = Modifier.size(18.dp))
                    }
                    
                    Spacer(modifier = Modifier.width(8.dp))

                    IconButton(
                        onClick = { showGenerateDialog = true },
                        modifier = Modifier
                            .size(36.dp)
                            .background(Color(0xFFE0E7FF), CircleShape)
                            .testTag("open_generate_dialog_button")
                    ) {
                        Icon(Icons.Default.Add, "Generate", tint = Color(0xFF4F46E5), modifier = Modifier.size(18.dp))
                    }
                }
            }
        }

        // Search and filter
        item {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                OutlinedTextField(
                    value = searchQuery,
                    onValueChange = { searchQuery = it },
                    placeholder = { Text("Cari kode / paket...") },
                    leadingIcon = { Icon(Icons.Default.Search, "Cari", tint = Color(0xFF64748B)) },
                    singleLine = true,
                    modifier = Modifier
                        .weight(1f)
                        .testTag("search_voucher_input"),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = Color(0xFF4F46E5),
                        unfocusedBorderColor = Color(0xFFE2E8F0),
                        focusedLabelColor = Color(0xFF4F46E5),
                        unfocusedLabelColor = Color(0xFF64748B),
                        focusedTextColor = Color(0xFF1E293B),
                        unfocusedTextColor = Color(0xFF1E293B)
                    )
                )

                Spacer(modifier = Modifier.width(10.dp))

                // Toggle Filter state
                IconButton(
                    onClick = {
                        filterType = when (filterType) {
                            "SEMUA" -> "BELUM TERPAKAI"
                            "BELUM TERPAKAI" -> "TERPAKAI"
                            else -> "SEMUA"
                        }
                    },
                    modifier = Modifier
                        .size(48.dp)
                        .background(Color(0xFFEEF2F6), RoundedCornerShape(12.dp))
                ) {
                    Icon(
                        imageVector = Icons.Default.FilterList,
                        contentDescription = "Filter",
                        tint = when (filterType) {
                            "SEMUA" -> Color(0xFF64748B)
                            "BELUM TERPAKAI" -> Color(0xFF166534)
                            else -> Color(0xFF4F46E5)
                        }
                    )
                }
            }

            // Small pills showing current filter
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 8.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                val currentText = when (filterType) {
                    "BELUM TERPAKAI" -> "Filter: Belum Terpakai"
                    "TERPAKAI" -> "Filter: Terpakai"
                    else -> "Menampilkan Semua"
                }
                Surface(
                    color = Color(0xFFE0E7FF),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Text(
                        text = currentText,
                        color = Color(0xFF4F46E5),
                        fontSize = 10.sp,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(horizontal = 10.dp, vertical = 4.dp)
                    )
                }
            }
        }

        if (filteredVouchers.isEmpty()) {
            item {
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = Color.White),
                    border = BorderStroke(1.dp, Color(0xFFE2E8F0))
                ) {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(30.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = "Tidak ada voucher ditemukan.",
                            color = Color(0xFF64748B),
                            fontSize = 12.sp
                        )
                    }
                }
            }
        } else {
            items(filteredVouchers) { voucher ->
                VoucherCardItem(
                    voucher = voucher,
                    onDelete = { viewModel.deleteVoucher(voucher.id) },
                    onPrint = { selectedVoucherForPrint = voucher },
                    onCopy = {
                        val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                        val clip = ClipData.newPlainText("Voucher Hotspot", "Kode Voucher: ${voucher.code}\nUsername: ${voucher.username}\nPassword: ${voucher.passwordStr}\nPaket: ${voucher.packageName}")
                        clipboard.setPrimaryClip(clip)
                        Toast.makeText(context, "Kode voucher copied!", Toast.LENGTH_SHORT).show()
                    }
                )
            }
        }

        item {
            Spacer(modifier = Modifier.height(16.dp))
        }
    }

    // dialog generator
    if (showGenerateDialog) {
        GenerateVouchersDialog(
            onDismiss = { showGenerateDialog = false },
            onGenerate = { count, packageName, price, prefix, length ->
                viewModel.generateVouchers(count, packageName, price, prefix, length)
                showGenerateDialog = false
                Toast.makeText(context, "$count voucher $packageName berhasil dibuat!", Toast.LENGTH_LONG).show()
            }
        )
    }

    // print template dialog
    selectedVoucherForPrint?.let { voucher ->
        VoucherPrintTemplateDialog(
            voucher = voucher,
            onDismiss = { selectedVoucherForPrint = null }
        )
    }
}

@Composable
fun VoucherCardItem(voucher: Voucher, onDelete: () -> Unit, onPrint: () -> Unit, onCopy: () -> Unit) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        border = BorderStroke(1.dp, Color(0xFFE2E8F0))
    ) {
        Column(modifier = Modifier.padding(14.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Default.LocalActivity, "Voucher", tint = Color(0xFF4F46E5), modifier = Modifier.size(16.dp))
                    Spacer(modifier = Modifier.width(6.dp))
                    Text(
                        text = voucher.packageName,
                        fontSize = 13.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF1E293B)
                    )
                }

                // Used / Unused badge
                Surface(
                    color = if (voucher.isUsed) Color(0xFFF1F5F9) else Color(0xFFDCFCE7),
                    shape = RoundedCornerShape(6.dp)
                ) {
                    Text(
                        text = if (voucher.isUsed) "Terpakai (${voucher.usedBy})" else "Tersedia",
                        color = if (voucher.isUsed) Color(0xFF64748B) else Color(0xFF166534),
                        fontSize = 9.sp,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.height(10.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column {
                    Text("KODE VOUCHER", fontSize = 10.sp, color = Color(0xFF64748B))
                    Text(
                        text = voucher.code,
                        fontSize = 18.sp,
                        fontWeight = FontWeight.ExtraBold,
                        color = Color(0xFF4F46E5),
                        letterSpacing = 1.sp
                    )
                }

                Column(horizontalAlignment = Alignment.End) {
                    Text("HARGA", fontSize = 10.sp, color = Color(0xFF64748B))
                    Text(
                        text = "Rp " + String.format("%,.0f", voucher.price),
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF1E293B)
                    )
                }
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Action triggers (copy, share, print template, delete)
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(Color(0xFFF8FAFC), RoundedCornerShape(12.dp))
                    .border(1.dp, Color(0xFFE2E8F0), RoundedCornerShape(12.dp))
                    .padding(6.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row {
                    // Copy
                    IconButton(onClick = onCopy, modifier = Modifier.size(32.dp)) {
                        Icon(Icons.Default.ContentCopy, "Salin", tint = Color(0xFF64748B), modifier = Modifier.size(16.dp))
                    }
                    // Print design
                    IconButton(onClick = onPrint, modifier = Modifier.size(32.dp)) {
                        Icon(Icons.Default.QrCode2, "Print View", tint = Color(0xFF64748B), modifier = Modifier.size(16.dp))
                    }
                }

                // Delete
                IconButton(onClick = onDelete, modifier = Modifier.size(32.dp)) {
                    Icon(Icons.Default.ClearAll, "Delete", tint = Color(0xFFEF4444), modifier = Modifier.size(16.dp))
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GenerateVouchersDialog(onDismiss: () -> Unit, onGenerate: (Int, String, Double, String, Int) -> Unit) {
    var count by remember { mutableStateOf("10") }
    var prefix by remember { mutableStateOf("NET") }
    var codeLength by remember { mutableStateOf("4") }

    val packages = listOf(
        Pair("Paket Hemat (1 Jam)", 2000.0),
        Pair("Paket Standard (5 Jam)", 5000.0),
        Pair("Paket Unlimited (24 Jam)", 15000.0),
        Pair("Paket Mingguan (7 Hari)", 35000.0),
        Pair("Paket Bulanan (30 Hari)", 100000.0)
    )

    var selectedPackageIndex by remember { mutableStateOf(0) }
    var expanded by remember { mutableStateOf(false) }

    Dialog(onDismissRequest = onDismiss) {
        Surface(
            shape = RoundedCornerShape(24.dp),
            color = Color.White,
            border = BorderStroke(1.dp, Color(0xFFE2E8F0)),
            modifier = Modifier.fillMaxWidth()
        ) {
            Column(
                modifier = Modifier
                    .padding(20.dp)
                    .fillMaxWidth(),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                Text(
                    text = "Generate Voucher Masal",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color(0xFF1E293B)
                )

                // Package dropdown list
                ExposedDropdownMenuBox(
                    expanded = expanded,
                    onExpandedChange = { expanded = !expanded }
                ) {
                    OutlinedTextField(
                        readOnly = true,
                        value = packages[selectedPackageIndex].first,
                        onValueChange = {},
                        label = { Text("Pilih Paket Hotspot") },
                        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded) },
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = Color(0xFF4F46E5),
                            unfocusedBorderColor = Color(0xFFE2E8F0),
                            focusedLabelColor = Color(0xFF4F46E5),
                            unfocusedLabelColor = Color(0xFF64748B),
                            focusedTextColor = Color(0xFF1E293B),
                            unfocusedTextColor = Color(0xFF1E293B)
                        ),
                        modifier = Modifier
                            .fillMaxWidth()
                            .menuAnchor()
                    )
                    ExposedDropdownMenu(
                        expanded = expanded,
                        onDismissRequest = { expanded = false },
                        modifier = Modifier.background(Color.White)
                    ) {
                        packages.forEachIndexed { idx, item ->
                            DropdownMenuItem(
                                text = { Text("${item.first} • Rp ${String.format("%,.0f", item.second)}", color = Color(0xFF1E293B)) },
                                onClick = {
                                    selectedPackageIndex = idx
                                    expanded = false
                                }
                            )
                        }
                    }
                }

                Row(modifier = Modifier.fillMaxWidth()) {
                    // Count
                    OutlinedTextField(
                        value = count,
                        onValueChange = { count = it },
                        label = { Text("Jumlah") },
                        singleLine = true,
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        modifier = Modifier
                            .weight(1f)
                            .testTag("gen_count_input"),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = Color(0xFF4F46E5),
                            unfocusedBorderColor = Color(0xFFE2E8F0),
                            focusedLabelColor = Color(0xFF4F46E5),
                            unfocusedLabelColor = Color(0xFF64748B),
                            focusedTextColor = Color(0xFF1E293B),
                            unfocusedTextColor = Color(0xFF1E293B)
                        )
                    )

                    Spacer(modifier = Modifier.width(10.dp))

                    // Code Length
                    OutlinedTextField(
                        value = codeLength,
                        onValueChange = { codeLength = it },
                        label = { Text("Panjang Kode") },
                        singleLine = true,
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        modifier = Modifier
                            .weight(1f)
                            .testTag("gen_length_input"),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = Color(0xFF4F46E5),
                            unfocusedBorderColor = Color(0xFFE2E8F0),
                            focusedLabelColor = Color(0xFF4F46E5),
                            unfocusedLabelColor = Color(0xFF64748B),
                            focusedTextColor = Color(0xFF1E293B),
                            unfocusedTextColor = Color(0xFF1E293B)
                        )
                    )
                }

                // Prefix
                OutlinedTextField(
                    value = prefix,
                    onValueChange = { prefix = it },
                    label = { Text("Prefix (Awalan Kode)") },
                    placeholder = { Text("NET") },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = Color(0xFF4F46E5),
                        unfocusedBorderColor = Color(0xFFE2E8F0),
                        focusedLabelColor = Color(0xFF4F46E5),
                        unfocusedLabelColor = Color(0xFF64748B),
                        focusedTextColor = Color(0xFF1E293B),
                        unfocusedTextColor = Color(0xFF1E293B)
                    )
                )

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.End
                ) {
                    TextButton(onClick = onDismiss) {
                        Text("Batal", color = Color(0xFF64748B))
                    }
                    Spacer(modifier = Modifier.width(8.dp))
                    Button(
                        onClick = {
                            val countNum = count.toIntOrNull() ?: 10
                            val lenNum = codeLength.toIntOrNull() ?: 4
                            val selPkg = packages[selectedPackageIndex]
                            onGenerate(countNum, selPkg.first, selPkg.second, prefix, lenNum)
                        },
                        colors = ButtonDefaults.buttonColors(
                            containerColor = Color(0xFF4F46E5),
                            contentColor = Color.White
                        )
                    ) {
                        Icon(Icons.Default.ShoppingCart, "Generate", modifier = Modifier.size(16.dp))
                        Spacer(modifier = Modifier.width(6.dp))
                        Text("Generate")
                    }
                }
            }
        }
    }
}

// Gorgeous printable ticket voucher card template dialog!
@Composable
fun VoucherPrintTemplateDialog(voucher: Voucher, onDismiss: () -> Unit) {
    Dialog(onDismissRequest = onDismiss) {
        Surface(
            shape = RoundedCornerShape(24.dp),
            color = Color.White, // High-contrast print style!
            border = BorderStroke(1.dp, Color(0xFFE2E8F0)),
            modifier = Modifier.fillMaxWidth()
        ) {
            Column(
                modifier = Modifier
                    .padding(24.dp)
                    .fillMaxWidth(),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                // Voucher Header
                Text(
                    text = "HOTSPOT NETMIKROTIK",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.ExtraBold,
                    color = Color.Black
                )

                // Separator Dot-line
                Text(
                    text = "- - - - - - - - - - - - - - - - - - - - -",
                    color = Color.Gray,
                    fontSize = 12.sp
                )

                Text(
                    text = voucher.packageName,
                    fontSize = 13.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.DarkGray
                )

                // Credentials Panel
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(Color(0xFFF1F5F9), RoundedCornerShape(12.dp))
                        .border(1.dp, Color.LightGray, RoundedCornerShape(12.dp))
                        .padding(14.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.spacedBy(6.dp)
                ) {
                    Text(
                        text = "KODE AKSES / LOGIN",
                        fontSize = 9.sp,
                        color = Color.Gray,
                        fontWeight = FontWeight.Bold
                    )
                    Text(
                        text = voucher.code,
                        fontSize = 28.sp,
                        fontWeight = FontWeight.ExtraBold,
                        color = Color.Black,
                        letterSpacing = 2.sp
                    )
                }

                // Terms info
                Column(
                    modifier = Modifier.fillMaxWidth(),
                    verticalArrangement = Arrangement.spacedBy(4.dp)
                ) {
                    Text("• Berlaku untuk 1 HP / Perangkat saja.", fontSize = 9.sp, color = Color.Gray)
                    Text("• Masukkan kode di atas pada halaman login hotspot.", fontSize = 9.sp, color = Color.Gray)
                    Text("• Hubungi CS jika ada kendala koneksi.", fontSize = 9.sp, color = Color.Gray)
                }

                Text(
                    text = "- - - - - - - - - - - - - - - - - - - - -",
                    color = Color.Gray,
                    fontSize = 12.sp
                )

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Harga: Rp " + String.format("%,.0f", voucher.price),
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color.Black
                    )
                    
                    Button(
                        onClick = onDismiss,
                        colors = ButtonDefaults.buttonColors(
                            containerColor = Color.Black,
                            contentColor = Color.White
                        ),
                        shape = RoundedCornerShape(8.dp)
                    ) {
                        Text("Selesai", fontSize = 11.sp)
                    }
                }
            }
        }
    }
}
