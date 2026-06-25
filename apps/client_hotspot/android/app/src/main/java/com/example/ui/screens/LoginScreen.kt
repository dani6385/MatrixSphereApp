package com.example.ui.screens

import androidx.compose.foundation.Image
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
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Dns
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Router
import androidx.compose.material.icons.filled.SettingsInputComponent
import androidx.compose.material.icons.filled.Speed
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
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
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.R
import com.example.ui.HotspotViewModel

@Composable
fun LoginScreen(viewModel: HotspotViewModel, modifier: Modifier = Modifier) {
    var host by remember { mutableStateOf("192.168.88.1") }
    var port by remember { mutableStateOf("8728") }
    var username by remember { mutableStateOf("admin") }
    var password by remember { mutableStateOf("") }
    var alias by remember { mutableStateOf("Hotspot Utama") }

    val scrollState = rememberScrollState()

    Box(
        modifier = modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(20.dp)
                .verticalScroll(scrollState),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Spacer(modifier = Modifier.height(20.dp))

            // Logo & Title
            Icon(
                imageVector = Icons.Default.Router,
                contentDescription = "Router Icon",
                tint = Color(0xFF4F46E5),
                modifier = Modifier
                    .size(64.dp)
                    .background(Color(0xFFE0E7FF), RoundedCornerShape(16.dp))
                    .padding(12.dp)
            )

            Spacer(modifier = Modifier.height(16.dp))

            Text(
                text = "NETMIKROTIK",
                fontSize = 28.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFF1E293B),
                letterSpacing = 2.sp
            )

            Text(
                text = "Mikrotik Hotspot Router Administrator",
                fontSize = 12.sp,
                color = Color(0xFF64748B),
                fontWeight = FontWeight.Medium,
                letterSpacing = 1.sp
            )

            Spacer(modifier = Modifier.height(24.dp))

            // Banner Image Generated earlier
            Card(
                shape = RoundedCornerShape(20.dp),
                modifier = Modifier
                    .fillMaxWidth()
                    .height(130.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White),
                border = androidx.compose.foundation.BorderStroke(1.dp, Color(0xFFE2E8F0))
            ) {
                Box(modifier = Modifier.fillMaxSize()) {
                    Image(
                        painter = painterResource(id = R.drawable.img_router_banner),
                        contentDescription = "Router Banner Illustration",
                        modifier = Modifier.fillMaxSize(),
                        contentScale = ContentScale.Crop
                    )
                    Box(
                        modifier = Modifier
                            .fillMaxSize()
                            .background(
                                Brush.verticalGradient(
                                    colors = listOf(
                                        Color.Transparent,
                                        Color(0xAA000000)
                                    )
                                )
                            )
                    )
                    Text(
                        text = "Kelola RouterOS & Voucher Hotspot Praktis dalam Satu Genggaman",
                        color = Color.White,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.SemiBold,
                        modifier = Modifier
                            .align(Alignment.BottomStart)
                            .padding(12.dp),
                        textAlign = TextAlign.Start
                    )
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Form Login
            Text(
                text = "Login Koneksi RouterOS API",
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFF1E293B),
                modifier = Modifier.fillMaxWidth(),
                textAlign = TextAlign.Start
            )

            Spacer(modifier = Modifier.height(12.dp))

            // IP Address Input
            OutlinedTextField(
                value = host,
                onValueChange = { host = it },
                label = { Text("Host / IP Address") },
                placeholder = { Text("192.168.88.1") },
                leadingIcon = { Icon(Icons.Default.Dns, contentDescription = "Host", tint = Color(0xFF64748B)) },
                singleLine = true,
                modifier = Modifier
                    .fillMaxWidth()
                    .testTag("host_input"),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedBorderColor = Color(0xFF4F46E5),
                    unfocusedBorderColor = Color(0xFFE2E8F0),
                    focusedLabelColor = Color(0xFF4F46E5),
                    unfocusedLabelColor = Color(0xFF64748B),
                    focusedTextColor = Color(0xFF1E293B),
                    unfocusedTextColor = Color(0xFF1E293B)
                )
            )

            Spacer(modifier = Modifier.height(12.dp))

            Row(modifier = Modifier.fillMaxWidth()) {
                // Port
                OutlinedTextField(
                    value = port,
                    onValueChange = { port = it },
                    label = { Text("Port API") },
                    placeholder = { Text("8728") },
                    leadingIcon = { Icon(Icons.Default.SettingsInputComponent, contentDescription = "Port", tint = Color(0xFF64748B)) },
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier
                        .weight(1f)
                        .testTag("port_input"),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = Color(0xFF4F46E5),
                        unfocusedBorderColor = Color(0xFFE2E8F0),
                        focusedLabelColor = Color(0xFF4F46E5),
                        unfocusedLabelColor = Color(0xFF64748B),
                        focusedTextColor = Color(0xFF1E293B),
                        unfocusedTextColor = Color(0xFF1E293B)
                    )
                )

                Spacer(modifier = Modifier.width(12.dp))

                // Alias Name
                OutlinedTextField(
                    value = alias,
                    onValueChange = { alias = it },
                    label = { Text("Alias Router") },
                    placeholder = { Text("Utama") },
                    singleLine = true,
                    modifier = Modifier
                        .weight(1f)
                        .testTag("alias_input"),
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

            Spacer(modifier = Modifier.height(12.dp))

            // Username API
            OutlinedTextField(
                value = username,
                onValueChange = { username = it },
                label = { Text("Username RouterOS") },
                placeholder = { Text("admin") },
                leadingIcon = { Icon(Icons.Default.Person, contentDescription = "User", tint = Color(0xFF64748B)) },
                singleLine = true,
                modifier = Modifier
                    .fillMaxWidth()
                    .testTag("username_input"),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedBorderColor = Color(0xFF4F46E5),
                    unfocusedBorderColor = Color(0xFFE2E8F0),
                    focusedLabelColor = Color(0xFF4F46E5),
                    unfocusedLabelColor = Color(0xFF64748B),
                    focusedTextColor = Color(0xFF1E293B),
                    unfocusedTextColor = Color(0xFF1E293B)
                )
            )

            Spacer(modifier = Modifier.height(12.dp))

            // Password API
            OutlinedTextField(
                value = password,
                onValueChange = { password = it },
                label = { Text("Password RouterOS") },
                leadingIcon = { Icon(Icons.Default.Lock, contentDescription = "Pass", tint = Color(0xFF64748B)) },
                singleLine = true,
                visualTransformation = PasswordVisualTransformation(),
                modifier = Modifier
                    .fillMaxWidth()
                    .testTag("password_input"),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedBorderColor = Color(0xFF4F46E5),
                    unfocusedBorderColor = Color(0xFFE2E8F0),
                    focusedLabelColor = Color(0xFF4F46E5),
                    unfocusedLabelColor = Color(0xFF64748B),
                    focusedTextColor = Color(0xFF1E293B),
                    unfocusedTextColor = Color(0xFF1E293B)
                )
            )

            Spacer(modifier = Modifier.height(24.dp))

            // Error Display
            viewModel.loginError?.let { err ->
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(Color(0xFFFEF2F2), RoundedCornerShape(12.dp))
                        .border(1.dp, Color(0xFFFCA5A5), RoundedCornerShape(12.dp))
                        .padding(12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.Info,
                        contentDescription = "Error",
                        tint = Color(0xFFEF4444),
                        modifier = Modifier.size(20.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = err,
                        color = Color(0xFF991B1B),
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Medium
                    )
                }
                Spacer(modifier = Modifier.height(16.dp))
            }

            // Connection indicator / action button
            if (viewModel.connectionStatus == "CONNECTING") {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(50.dp)
                        .background(Color(0xFFEFF6FF), RoundedCornerShape(12.dp))
                        .border(1.dp, Color(0xFFBFDBFE), RoundedCornerShape(12.dp)),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.Center
                ) {
                    CircularProgressIndicator(
                        modifier = Modifier.size(20.dp),
                        strokeWidth = 2.dp,
                        color = Color(0xFF3B82F6)
                    )
                    Spacer(modifier = Modifier.width(12.dp))
                    Text(
                        text = "Menghubungkan Router...",
                        color = Color(0xFF1E40AF),
                        fontSize = 14.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                }
            } else {
                Button(
                    onClick = {
                        viewModel.login(host, port, username, password, alias, isDemo = false)
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(50.dp)
                        .testTag("connect_router_button"),
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFF4F46E5),
                        contentColor = Color.White
                    )
                ) {
                    Icon(Icons.Default.Speed, contentDescription = "Connect", modifier = Modifier.size(18.dp))
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = "HUBUNGKAN ROUTER (API)",
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Bold
                    )
                }

                Spacer(modifier = Modifier.height(12.dp))

                OutlinedButton(
                    onClick = {
                        viewModel.login("demo.hotspot", "8728", "demo", "demo", "Mikrotik Demo Server", isDemo = true)
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(50.dp)
                        .testTag("demo_mode_button"),
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.outlinedButtonColors(
                        contentColor = Color(0xFF4F46E5)
                    ),
                    border = androidx.compose.foundation.BorderStroke(1.dp, Color(0xFF4F46E5))
                ) {
                    Text(
                        text = "COBA MODE DEMO (SIMULASI)",
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }

            Spacer(modifier = Modifier.height(30.dp))
        }
    }
}
