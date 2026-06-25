package com.example.ui.screens

import android.widget.Toast
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
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
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Logout
import androidx.compose.material.icons.filled.Router
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.Shield
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.ui.HotspotViewModel

@Composable
fun SettingsScreen(viewModel: HotspotViewModel, modifier: Modifier = Modifier) {
    val context = LocalContext.current
    val router = viewModel.activeRouter

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Text(
            text = "PENGATURAN ROUTER",
            fontSize = 18.sp,
            fontWeight = FontWeight.Bold,
            color = Color(0xFF1E293B)
        )
        Text(
            text = "Kelola data router, database, dan sesi login.",
            fontSize = 12.sp,
            color = Color(0xFF64748B)
        )

        // 1. ROUTER PROFILE SPEC
        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(containerColor = Color.White),
            border = BorderStroke(1.dp, Color(0xFFE2E8F0))
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(
                        imageVector = Icons.Default.Router,
                        contentDescription = "Router",
                        tint = Color(0xFF4F46E5),
                        modifier = Modifier
                            .size(36.dp)
                            .background(Color(0xFFE0E7FF), CircleShape)
                            .padding(8.dp)
                    )
                    Spacer(modifier = Modifier.width(12.dp))
                    Column {
                        Text(
                            text = router?.aliasName ?: "Hotspot Router",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color(0xFF1E293B)
                        )
                        Text(
                            text = "Koneksi via API Port: ${router?.port ?: 8728}",
                            fontSize = 11.sp,
                            color = Color(0xFF64748B)
                        )
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Column {
                        Text("HOST / IP", fontSize = 10.sp, color = Color(0xFF64748B))
                        Text(router?.host ?: "unknown", fontSize = 12.sp, color = Color(0xFF1E293B), fontWeight = FontWeight.Bold)
                    }
                    Column(horizontalAlignment = Alignment.End) {
                        Text("USERNAME API", fontSize = 10.sp, color = Color(0xFF64748B))
                        Text(router?.username ?: "admin", fontSize = 12.sp, color = Color(0xFF1E293B), fontWeight = FontWeight.Bold)
                    }
                }
            }
        }

        // 2. PRIVACY & SECURITY CARD
        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(containerColor = Color.White),
            border = BorderStroke(1.dp, Color(0xFFE2E8F0))
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(Icons.Default.Shield, "Keamanan", tint = Color(0xFF166534), modifier = Modifier.size(24.dp))
                Spacer(modifier = Modifier.width(12.dp))
                Column {
                    Text("Koneksi API Terenkripsi", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = Color(0xFF1E293B))
                    Text("Kredensial login tersimpan dengan aman dalam SQLite lokal.", fontSize = 10.sp, color = Color(0xFF64748B))
                }
            }
        }

        // 3. APP INFO
        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(containerColor = Color.White),
            border = BorderStroke(1.dp, Color(0xFFE2E8F0))
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Default.Info, "Tentang", tint = Color(0xFFB45309), modifier = Modifier.size(20.dp))
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("Tentang Aplikasi", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = Color(0xFF1E293B))
                }

                Spacer(modifier = Modifier.height(10.dp))
                Text("NetMikrotik Hotspot Router Administrator", fontSize = 12.sp, fontWeight = FontWeight.Medium, color = Color(0xFF1E293B))
                Text("Version 1.0.0 (Native Android Compose)", fontSize = 10.sp, color = Color(0xFF64748B))
                Spacer(modifier = Modifier.height(6.dp))
                Text("Dikembangkan untuk pengelolaan mandiri hotspot voucher di kos-kosan, kafe, warkop, maupun jaringan RTRW Net.", fontSize = 11.sp, color = Color(0xFF475569), lineHeight = 15.sp)
            }
        }

        Spacer(modifier = Modifier.weight(1f))

        // 4. LOGOUT BUTTON
        Button(
            onClick = {
                viewModel.logout()
                Toast.makeText(context, "Koneksi router terputus.", Toast.LENGTH_SHORT).show()
            },
            modifier = Modifier
                .fillMaxWidth()
                .height(48.dp)
                .testTag("logout_button"),
            colors = ButtonDefaults.buttonColors(
                containerColor = Color(0xFFFEE2E2),
                contentColor = Color(0xFF991B1B)
            ),
            border = BorderStroke(1.dp, Color(0xFFFCA5A5)),
            shape = RoundedCornerShape(12.dp)
        ) {
            Icon(Icons.Default.Logout, "Logout", modifier = Modifier.size(16.dp))
            Spacer(modifier = Modifier.width(8.dp))
            Text("PUTUSKAN ROUTER (LOGOUT)", fontSize = 12.sp, fontWeight = FontWeight.Bold)
        }
    }
}
