package com.example.ui.screens

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
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
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Campaign
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Memory
import androidx.compose.material.icons.filled.NetworkCheck
import androidx.compose.material.icons.filled.People
import androidx.compose.material.icons.filled.PersonalVideo
import androidx.compose.material.icons.filled.Router
import androidx.compose.material.icons.filled.SignalCellularAlt
import androidx.compose.material.icons.filled.Speed
import androidx.compose.material.icons.filled.Timelapse
import androidx.compose.material.icons.filled.Wifi
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
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.foundation.BorderStroke
import androidx.compose.ui.window.Dialog
import com.example.data.MadingItem
import com.example.data.TrafficPoint
import com.example.ui.HotspotViewModel
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(viewModel: HotspotViewModel, modifier: Modifier = Modifier) {
    val trafficHistory by viewModel.trafficHistory.collectAsState()
    val madingList by viewModel.madingItems.collectAsState()

    var showAddMadingDialog by remember { mutableStateOf(false) }

    LazyColumn(
        modifier = modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .padding(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // 1. HEADER PROFILE & STATUS
        item {
            Spacer(modifier = Modifier.height(16.dp))
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(Color.White, RoundedCornerShape(24.dp))
                    .border(1.dp, Color(0xFFE2E8F0), RoundedCornerShape(24.dp))
                    .padding(16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.Router,
                    contentDescription = "Router",
                    tint = Color(0xFF4F46E5),
                    modifier = Modifier
                        .size(50.dp)
                        .background(Color(0xFFE0E7FF), CircleShape)
                        .padding(10.dp)
                )

                Spacer(modifier = Modifier.width(12.dp))

                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = viewModel.activeRouter?.aliasName ?: "Mikrotik Router",
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF1E293B)
                    )
                    Text(
                        text = "IP: ${viewModel.activeRouter?.host ?: "unknown"}",
                        fontSize = 12.sp,
                        color = Color(0xFF64748B)
                    )
                }

                // Status Indicator
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier
                        .background(Color(0xFFDCFCE7), RoundedCornerShape(12.dp))
                        .padding(horizontal = 10.dp, vertical = 6.dp)
                ) {
                    Box(
                        modifier = Modifier
                            .size(8.dp)
                            .background(
                                color = if (viewModel.connectionStatus == "CONNECTED") Color(0xFF166534) else Color(0xFFEF4444),
                                shape = CircleShape
                            )
                    )
                    Spacer(modifier = Modifier.width(6.dp))
                    Text(
                        text = if (viewModel.connectionStatus == "CONNECTED") "Aktif" else "Offline",
                        fontSize = 11.sp,
                        color = if (viewModel.connectionStatus == "CONNECTED") Color(0xFF166534) else Color(0xFFEF4444),
                        fontWeight = FontWeight.Bold
                    )
                }
            }
        }

        // 2. DETAILED RESOURCE METRICS
        item {
            val stats = viewModel.systemResource
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                // Users Card
                Card(
                    modifier = Modifier.weight(1f),
                    colors = CardDefaults.cardColors(containerColor = Color.White),
                    border = BorderStroke(1.dp, Color(0xFFE2E8F0))
                ) {
                    Column(modifier = Modifier.padding(12.dp)) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(Icons.Default.People, "Users", tint = Color(0xFF4F46E5), modifier = Modifier.size(16.dp))
                            Spacer(modifier = Modifier.width(6.dp))
                            Text("User Aktif", fontSize = 11.sp, color = Color(0xFF64748B))
                        }
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "${stats?.activeUsers ?: 0} Online",
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color(0xFF1E293B)
                        )
                    }
                }

                // CPU Card
                Card(
                    modifier = Modifier.weight(1f),
                    colors = CardDefaults.cardColors(containerColor = Color.White),
                    border = BorderStroke(1.dp, Color(0xFFE2E8F0))
                ) {
                    Column(modifier = Modifier.padding(12.dp)) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(Icons.Default.Memory, "CPU", tint = Color(0xFFF59E0B), modifier = Modifier.size(16.dp))
                            Spacer(modifier = Modifier.width(6.dp))
                            Text("Beban CPU", fontSize = 11.sp, color = Color(0xFF64748B))
                        }
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "${stats?.cpuUsage ?: 0}%",
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color(0xFF1E293B)
                        )
                    }
                }

                // RAM Card
                Card(
                    modifier = Modifier.weight(1f),
                    colors = CardDefaults.cardColors(containerColor = Color.White),
                    border = BorderStroke(1.dp, Color(0xFFE2E8F0))
                ) {
                    Column(modifier = Modifier.padding(12.dp)) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(Icons.Default.NetworkCheck, "RAM", tint = Color(0xFF3B82F6), modifier = Modifier.size(16.dp))
                            Spacer(modifier = Modifier.width(6.dp))
                            Text("Memori", fontSize = 11.sp, color = Color(0xFF64748B))
                        }
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "${stats?.memoryUsedMb ?: 0}/${stats?.memoryTotalMb ?: 512}MB",
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color(0xFF1E293B)
                        )
                    }
                }
            }
        }

        // 3. REAL-TIME TRAFFIC MINI CHART
        item {
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(containerColor = Color.White),
                border = BorderStroke(1.dp, Color(0xFFE2E8F0))
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(
                                imageVector = Icons.Default.SignalCellularAlt,
                                contentDescription = "Trafik",
                                tint = Color(0xFF4F46E5),
                                modifier = Modifier.size(18.dp)
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                text = "Trafik Hotspot Real-Time",
                                fontSize = 14.sp,
                                fontWeight = FontWeight.Bold,
                                color = Color(0xFF1E293B)
                              )
                        }

                        // Current Speeds
                        val latestSpeed = trafficHistory.lastOrNull()
                        val dlSpeedFormatted = formatSpeed(latestSpeed?.downloadSpeedKbps ?: 0.0)
                        val ulSpeedFormatted = formatSpeed(latestSpeed?.uploadSpeedKbps ?: 0.0)

                        Text(
                            text = "↓ $dlSpeedFormatted  ↑ $ulSpeedFormatted",
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color(0xFF4F46E5)
                        )
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    // Line Graph Canvas
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(100.dp)
                            .background(Color(0xFFF8FAFC), RoundedCornerShape(12.dp))
                            .border(1.dp, Color(0xFFE2E8F0), RoundedCornerShape(12.dp))
                            .padding(8.dp)
                    ) {
                        TrafficLineChart(points = trafficHistory)
                    }
                }
            }
        }

        // 4. SELECTED USER PACKAGE INFO (INFO USER YANG DIGUNAKAN)
        item {
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(containerColor = Color.White),
                border = BorderStroke(1.dp, Color(0xFFE2E8F0))
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(Icons.Default.Wifi, "Hotspot", tint = Color(0xFF4F46E5), modifier = Modifier.size(18.dp))
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                text = "Paket Hotspot Terpilih & Sesi",
                                fontSize = 14.sp,
                                fontWeight = FontWeight.Bold,
                                color = Color(0xFF1E293B)
                            )
                        }

                        Surface(
                            color = Color(0xFFE0E7FF),
                            shape = RoundedCornerShape(6.dp)
                        ) {
                            Text(
                                text = "NET-X7A3",
                                fontSize = 10.sp,
                                fontWeight = FontWeight.Bold,
                                color = Color(0xFF4F46E5),
                                modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(12.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Column {
                            Text("Paket", fontSize = 10.sp, color = Color(0xFF64748B))
                            Text("Paket Hemat (1 Jam)", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = Color(0xFF1E293B))
                        }
                        Column(horizontalAlignment = Alignment.End) {
                            Text("Masa Aktif Sisa", fontSize = 10.sp, color = Color(0xFF64748B))
                            val minutes = viewModel.currentUserTimeLeftSeconds / 60
                            val seconds = viewModel.currentUserTimeLeftSeconds % 60
                            val textTime = String.format("%02d m %02d s", minutes, seconds)
                            Text(
                                text = textTime,
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Bold,
                                color = if (viewModel.currentUserTimeLeftSeconds <= 600) Color(0xFFEF4444) else Color(0xFF166534)
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(12.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Column {
                            Text("IP Address Anda", fontSize = 10.sp, color = Color(0xFF64748B))
                            Text("192.168.88.254", fontSize = 12.sp, fontWeight = FontWeight.Medium, color = Color(0xFF1E293B))
                        }
                        Column(horizontalAlignment = Alignment.End) {
                            Text("MAC Address", fontSize = 10.sp, color = Color(0xFF64748B))
                            Text("7C:D3:0A:11:22:33", fontSize = 12.sp, fontWeight = FontWeight.Medium, color = Color(0xFF1E293B))
                        }
                    }
                }
            }
        }

        // 5. NOTICE BOARD (MADING INFORMASI)
        item {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(
                        imageVector = Icons.Default.Campaign,
                        contentDescription = "Mading",
                        tint = Color(0xFF4F46E5),
                        modifier = Modifier.size(20.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = "Mading Informasi Hotspot",
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF1E293B)
                    )
                }

                IconButton(
                    onClick = { showAddMadingDialog = true },
                    modifier = Modifier
                        .size(32.dp)
                        .background(Color(0xFFE0E7FF), CircleShape)
                        .testTag("add_mading_button")
                ) {
                    Icon(Icons.Default.Add, "Tambah Info", tint = Color(0xFF4F46E5), modifier = Modifier.size(16.dp))
                }
            }
        }

        if (madingList.isEmpty()) {
            item {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(100.dp)
                        .background(Color.White, RoundedCornerShape(12.dp))
                        .border(1.dp, Color(0xFFE2E8F0), RoundedCornerShape(12.dp))
                        .padding(16.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = "Belum ada pengumuman di mading.",
                        color = Color(0xFF64748B),
                        fontSize = 12.sp
                    )
                }
            }
        } else {
            items(madingList) { mading ->
                MadingItemCard(
                    mading = mading,
                    onDelete = { viewModel.deleteMadingItem(mading.id) }
                )
            }
        }

        item {
            Spacer(modifier = Modifier.height(16.dp))
        }
    }

    // Dialogue to Add Mading Item
    if (showAddMadingDialog) {
        AddMadingDialog(
            onDismiss = { showAddMadingDialog = false },
            onSave = { title, content, category ->
                viewModel.addMadingItem(title, content, category)
                showAddMadingDialog = false
            }
        )
    }
}

@Composable
fun MadingItemCard(mading: MadingItem, onDelete: () -> Unit) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        border = BorderStroke(1.dp, Color(0xFFE2E8F0))
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Category Tag
                val (tagBg, tagText) = when (mading.category) {
                    "MAINTENANCE" -> Pair(Color(0xFFFEE2E2), Color(0xFF991B1B))
                    "PROMO" -> Pair(Color(0xFFDCFCE7), Color(0xFF166534))
                    "INFO" -> Pair(Color(0xFFE0E7FF), Color(0xFF3730A3))
                    else -> Pair(Color(0xFFFEF3C7), Color(0xFF92400E)) // PENGUMUMAN
                }

                Surface(
                    color = tagBg,
                    shape = RoundedCornerShape(6.dp)
                ) {
                    Text(
                        text = mading.category,
                        color = tagText,
                        fontSize = 9.sp,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
                    )
                }

                // Delete Button for Management
                IconButton(
                    onClick = onDelete,
                    modifier = Modifier.size(24.dp)
                ) {
                    Icon(
                        imageVector = Icons.Default.Delete,
                        contentDescription = "Hapus",
                        tint = Color(0xFF94A3B8),
                        modifier = Modifier.size(16.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.height(10.dp))

            Text(
                text = mading.title,
                fontSize = 14.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFF1E293B)
            )

            Spacer(modifier = Modifier.height(6.dp))

            Text(
                text = mading.content,
                fontSize = 12.sp,
                color = Color(0xFF475569),
                lineHeight = 16.sp
            )

            Spacer(modifier = Modifier.height(12.dp))

            val sdf = SimpleDateFormat("dd MMM yyyy, HH:mm", Locale.getDefault())
            Text(
                text = "Diposting oleh ${mading.author} • ${sdf.format(Date(mading.timestamp))}",
                fontSize = 10.sp,
                color = Color(0xFF64748B)
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddMadingDialog(onDismiss: () -> Unit, onSave: (String, String, String) -> Unit) {
    var title by remember { mutableStateOf("") }
    var content by remember { mutableStateOf("") }
    var category by remember { mutableStateOf("INFO") }
    val categories = listOf("INFO", "PROMO", "MAINTENANCE", "PENGUMUMAN")
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
                    text = "Tambah Mading Informasi",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color(0xFF1E293B)
                )

                OutlinedTextField(
                    value = title,
                    onValueChange = { title = it },
                    label = { Text("Judul Pengumuman") },
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

                // Category dropdown
                ExposedDropdownMenuBox(
                    expanded = expanded,
                    onExpandedChange = { expanded = !expanded }
                ) {
                    OutlinedTextField(
                        readOnly = true,
                        value = category,
                        onValueChange = {},
                        label = { Text("Kategori") },
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
                        categories.forEach { selectionOption ->
                            DropdownMenuItem(
                                text = { Text(selectionOption, color = Color(0xFF1E293B)) },
                                onClick = {
                                    category = selectionOption
                                    expanded = false
                                }
                            )
                        }
                    }
                }

                OutlinedTextField(
                    value = content,
                    onValueChange = { content = it },
                    label = { Text("Isi Pengumuman") },
                    minLines = 3,
                    maxLines = 5,
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
                            if (title.isNotEmpty() && content.isNotEmpty()) {
                                onSave(title, content, category)
                            }
                        },
                        colors = ButtonDefaults.buttonColors(
                            containerColor = Color(0xFF4F46E5),
                            contentColor = Color.White
                        )
                    ) {
                        Text("Posting")
                    }
                }
            }
        }
    }
}

@Composable
fun TrafficLineChart(points: List<TrafficPoint>) {
    Canvas(modifier = Modifier.fillMaxSize()) {
        if (points.size < 2) return@Canvas

        val maxSpeed = (points.maxOf { maxOf(it.downloadSpeedKbps, it.uploadSpeedKbps) }).coerceAtLeast(1000.0)

        val width = size.width
        val height = size.height

        val stepX = width / (points.size - 1)

        val dlPath = Path()
        val ulPath = Path()

        points.forEachIndexed { index, trafficPoint ->
            val x = index * stepX
            val yDl = height - ((trafficPoint.downloadSpeedKbps / maxSpeed) * height).toFloat().coerceIn(0f, height)
            val yUl = height - ((trafficPoint.uploadSpeedKbps / maxSpeed) * height).toFloat().coerceIn(0f, height)

            if (index == 0) {
                dlPath.moveTo(x, yDl)
                ulPath.moveTo(x, yUl)
            } else {
                dlPath.lineTo(x, yDl)
                ulPath.lineTo(x, yUl)
            }
        }

        // Draw gridlines
        val gridLinesCount = 3
        val gridStepY = height / gridLinesCount
        for (i in 1 until gridLinesCount) {
            val gridY = i * gridStepY
            drawLine(
                color = Color(0xFFE2E8F0),
                start = Offset(0f, gridY),
                end = Offset(width, gridY),
                strokeWidth = 1f
            )
        }

        // Draw paths
        drawPath(
            path = dlPath,
            color = Color(0xFF4F46E5),
            style = Stroke(width = 4f)
        )

        drawPath(
            path = ulPath,
            color = Color(0xFF3B82F6),
            style = Stroke(width = 4f)
        )
    }
}

fun formatSpeed(kbps: Double): String {
    return if (kbps > 1024) {
        String.format("%.2f Mbps", kbps / 1024.0)
    } else {
        String.format("%.0f Kbps", kbps)
    }
}
