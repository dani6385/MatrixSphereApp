package com.example.ui.screens

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
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
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.NetworkWifi
import androidx.compose.material.icons.filled.NotificationsActive
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Speed
import androidx.compose.material.icons.filled.SyncAlt
import androidx.compose.material.icons.filled.Warning
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.ui.HotspotViewModel

@Composable
fun AccountScreen(viewModel: HotspotViewModel, modifier: Modifier = Modifier) {
    val mins = viewModel.currentUserTimeLeftSeconds / 60
    val secs = viewModel.currentUserTimeLeftSeconds % 60
    val formattedTime = String.format("%02d Menit %02d Detik", mins, secs)

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Text(
            text = "INFORMASI KONEKSI AKUN",
            fontSize = 18.sp,
            fontWeight = FontWeight.Bold,
            color = Color(0xFF1E293B)
        )
        Text(
            text = "Informasi detail mengenai sesi hotspot Anda yang sedang aktif.",
            fontSize = 12.sp,
            color = Color(0xFF64748B)
        )

        // 1. ACCOUNT OVERVIEW PANEL
        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(containerColor = Color.White),
            border = BorderStroke(1.dp, Color(0xFFE2E8F0))
        ) {
            Column(
                modifier = Modifier.padding(20.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Icon(
                    imageVector = Icons.Default.AccountCircle,
                    contentDescription = "User Avatar",
                    tint = Color(0xFF4F46E5),
                    modifier = Modifier.size(64.dp)
                )

                Spacer(modifier = Modifier.height(10.dp))

                Text(
                    text = "Voucher: NET-X7A3",
                    fontSize = 18.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color(0xFF1E293B)
                )

                Text(
                    text = "Paket Hemat (1 Jam) • Aktif",
                    fontSize = 12.sp,
                    color = Color(0xFF166534),
                    fontWeight = FontWeight.Bold
                )

                Spacer(modifier = Modifier.height(20.dp))

                // Connection details grid
                Column(
                    modifier = Modifier.fillMaxWidth(),
                    verticalArrangement = Arrangement.spacedBy(10.dp)
                ) {
                    InfoDetailRow(label = "Alamat IP", value = "192.168.88.254")
                    InfoDetailRow(label = "Alamat MAC", value = "7C:D3:0A:11:22:33")
                    InfoDetailRow(label = "Batas Kecepatan (Up/Down)", value = "1 Mbps / 5 Mbps")
                    InfoDetailRow(label = "Total Kuota Terpakai", value = "324 MB / Unlimited")
                }
            }
        }

        // 2. DYNAMIC COUNTDOWN & ACTIVE WARNING SYSTEM
        val isWarning = viewModel.currentUserTimeLeftSeconds <= 600
        val cardBg = if (isWarning) Color(0xFFFEF2F2) else Color(0xFFEFF6FF)
        val cardBorderColor = if (isWarning) Color(0xFFFCA5A5) else Color(0xFFBFDBFE)
        val accentColor = if (isWarning) Color(0xFF991B1B) else Color(0xFF1E40AF)
        val textDescColor = if (isWarning) Color(0xFF7F1D1D) else Color(0xFF1E3A8A)

        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(containerColor = cardBg),
            border = BorderStroke(1.dp, cardBorderColor)
        ) {
            Column(
                modifier = Modifier.padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.Center
                ) {
                    Icon(
                        imageVector = if (isWarning) Icons.Default.Warning else Icons.Default.NotificationsActive,
                        contentDescription = "Warning",
                        tint = accentColor,
                        modifier = Modifier.size(20.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = if (isWarning) "PERINGATAN MASA AKTIF!" else "INFORMASI MASA AKTIF",
                        fontSize = 13.sp,
                        fontWeight = FontWeight.Bold,
                        color = accentColor
                    )
                }

                Spacer(modifier = Modifier.height(10.dp))

                Text(
                    text = formattedTime,
                    fontSize = 24.sp,
                    fontWeight = FontWeight.ExtraBold,
                    color = accentColor
                )

                Spacer(modifier = Modifier.height(8.dp))

                Text(
                    text = if (isWarning) {
                        "Pemberitahuan: Masa aktif voucher Anda tinggal sedikit lagi! Silakan beli voucher baru sekarang untuk mencegah internet putus secara tiba-tiba."
                    } else {
                        "Internet Anda aman. Notifikasi sistem otomatis akan muncul ketika masa aktif Anda di bawah 10 Menit."
                    },
                    fontSize = 11.sp,
                    color = textDescColor,
                    textAlign = TextAlign.Center,
                    lineHeight = 15.sp
                )

                Spacer(modifier = Modifier.height(16.dp))

                // Interactive Simulator triggers
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceEvenly
                ) {
                    // Force Warning trigger to test flow instantly
                    OutlinedButton(
                        onClick = {
                            viewModel.currentUserTimeLeftSeconds = 595L // Forces countdown immediately below 10 mins
                            viewModel.isNotificationDismissed = false
                        },
                        colors = ButtonDefaults.outlinedButtonColors(
                            contentColor = Color(0xFFEF4444)
                        ),
                        border = BorderStroke(1.dp, Color(0xFFEF4444)),
                        shape = RoundedCornerShape(8.dp),
                        modifier = Modifier
                            .weight(1f)
                            .testTag("force_warning_btn")
                    ) {
                        Text(
                            text = "Uji Peringatan (API)",
                            fontSize = 11.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }

                    Spacer(modifier = Modifier.width(10.dp))

                    // Reset Timer back to 1 Hour
                    Button(
                        onClick = {
                            viewModel.resetCountdown()
                        },
                        colors = ButtonDefaults.buttonColors(
                            containerColor = Color(0xFF10B981),
                            contentColor = Color.White
                        ),
                        shape = RoundedCornerShape(8.dp),
                        modifier = Modifier
                            .weight(1f)
                            .testTag("reset_countdown_btn")
                    ) {
                        Icon(Icons.Default.Refresh, "Reset", modifier = Modifier.size(14.dp))
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(
                            text = "Isi Ulang Sesi",
                            fontSize = 11.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun InfoDetailRow(label: String, value: String) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .background(Color(0xFFF8FAFC), RoundedCornerShape(12.dp))
            .border(1.dp, Color(0xFFE2E8F0), RoundedCornerShape(12.dp))
            .padding(12.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = label,
            fontSize = 11.sp,
            color = Color(0xFF64748B),
            fontWeight = FontWeight.Medium
        )
        Text(
            text = value,
            fontSize = 12.sp,
            color = Color(0xFF1E293B),
            fontWeight = FontWeight.Bold
        )
    }
}
