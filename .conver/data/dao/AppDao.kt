package com.example.data.dao

import androidx.room.*
import com.example.data.model.*
import kotlinx.coroutines.flow.Flow

@Dao
interface AppDao {
    // App Access Queries
    @Query("SELECT * FROM app_access ORDER BY usageMinutes DESC")
    fun getAppAccessList(): Flow<List<AppAccess>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAppAccess(app: AppAccess)

    @Query("UPDATE app_access SET isBlocked = :isBlocked WHERE packageName = :packageName")
    suspend fun updateAppAccessBlockStatus(packageName: String, isBlocked: Boolean)

    // Seller Queries
    @Query("SELECT * FROM sellers ORDER BY id DESC")
    fun getSellers(): Flow<List<Seller>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSeller(seller: Seller)

    @Query("UPDATE sellers SET status = :status WHERE id = :id")
    suspend fun updateSellerStatus(id: Int, status: String)

    @Query("UPDATE sellers SET isBanned = :isBanned, banReason = :banReason WHERE id = :id")
    suspend fun updateSellerBanStatus(id: Int, isBanned: Boolean, banReason: String?)

    @Query("DELETE FROM sellers WHERE id = :id")
    suspend fun deleteSeller(id: Int)

    // Approval Request Queries
    @Query("SELECT * FROM approval_requests ORDER BY timestamp DESC")
    fun getApprovalRequests(): Flow<List<ApprovalRequest>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertApprovalRequest(request: ApprovalRequest)

    @Query("UPDATE approval_requests SET status = :status WHERE id = :id")
    suspend fun updateApprovalStatus(id: Int, status: String)

    // Notification Queries
    @Query("SELECT * FROM notifications ORDER BY timestamp DESC")
    fun getNotifications(): Flow<List<Notification>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertNotification(notification: Notification)

    @Query("UPDATE notifications SET isRead = 1 WHERE id = :id")
    suspend fun markNotificationAsRead(id: Int)

    @Query("UPDATE notifications SET isRead = 1")
    suspend fun markAllNotificationsAsRead()

    // User Profile Queries
    @Query("SELECT * FROM user_profiles WHERE username = :username LIMIT 1")
    suspend fun getUserProfileDirect(username: String): UserProfile?

    @Query("SELECT * FROM user_profiles WHERE username = :username LIMIT 1")
    fun getUserProfile(username: String): Flow<UserProfile?>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertUserProfile(profile: UserProfile)
}
