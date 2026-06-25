package com.example.data

import androidx.room.Entity
import androidx.room.PrimaryKey
import java.util.UUID

@Entity(tableName = "router_profiles")
data class RouterProfile(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val host: String,
    val port: Int = 8728, // Default API port, or 80/443 for REST API
    val username: String,
    val password: String,
    val aliasName: String,
    val isDemo: Boolean = false,
    val isActive: Boolean = false
)

@Entity(tableName = "vouchers")
data class Voucher(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val code: String = UUID.randomUUID().toString().take(6).uppercase(),
    val username: String = code,
    val passwordStr: String = code,
    val packageName: String,
    val price: Double,
    val limitBytes: Long = 0, // 0 means unlimited
    val limitTimeSeconds: Long = 0, // 0 means unlimited
    val isUsed: Boolean = false,
    val usedBy: String? = null,
    val createdAt: Long = System.currentTimeMillis()
)

@Entity(tableName = "mading_items")
data class MadingItem(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val title: String,
    val content: String,
    val author: String = "Admin",
    val timestamp: Long = System.currentTimeMillis(),
    val category: String // "INFO", "PROMO", "MAINTENANCE", "PENGUMUMAN"
)

data class ActiveSession(
    val id: String = UUID.randomUUID().toString(),
    val username: String,
    val ipAddress: String,
    val macAddress: String,
    val uptimeSeconds: Long,
    val bytesIn: Long,
    val bytesOut: Long,
    val comment: String? = null
)

data class TrafficPoint(
    val timestamp: Long,
    val downloadSpeedKbps: Double,
    val uploadSpeedKbps: Double
)

data class SystemResource(
    val cpuUsage: Int, // percentage
    val memoryUsedMb: Long,
    val memoryTotalMb: Long,
    val uptime: String,
    val activeUsers: Int,
    val totalVouchers: Int
)
