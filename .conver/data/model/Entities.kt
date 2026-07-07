package com.example.data.model

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "app_access")
data class AppAccess(
    @PrimaryKey val packageName: String,
    val appName: String,
    val usageMinutes: Int,
    val isBlocked: Boolean,
    val category: String,
    val limitMinutes: Int = 60
)

@Entity(tableName = "sellers")
data class Seller(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val name: String,
    val email: String,
    val storeName: String,
    val status: String, // "Aktif" or "Tidak Aktif"
    val contact: String,
    val isBanned: Boolean = false,
    val banReason: String? = null
)

@Entity(tableName = "approval_requests")
data class ApprovalRequest(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val title: String,
    val details: String,
    val requesterName: String,
    val timestamp: Long = System.currentTimeMillis(),
    val status: String // "Menunggu", "Disetujui", "Ditolak"
)

@Entity(tableName = "notifications")
data class Notification(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val message: String,
    val timestamp: Long = System.currentTimeMillis(),
    val isRead: Boolean = false
)

@Entity(tableName = "user_profiles")
data class UserProfile(
    @PrimaryKey val username: String,
    val fullName: String,
    val email: String,
    val phone: String,
    val passwordHash: String,
    val isTwoFactorEnabled: Boolean = false
)
