package com.example.data.repository

import com.example.data.dao.AppDao
import com.example.data.model.*
import kotlinx.coroutines.flow.Flow

class AppRepository(private val appDao: AppDao) {

    // App Access
    val appAccessList: Flow<List<AppAccess>> = appDao.getAppAccessList()

    suspend fun insertAppAccess(app: AppAccess) {
        appDao.insertAppAccess(app)
    }

    suspend fun updateAppAccessBlockStatus(packageName: String, isBlocked: Boolean) {
        appDao.updateAppAccessBlockStatus(packageName, isBlocked)
    }

    // Sellers
    val sellers: Flow<List<Seller>> = appDao.getSellers()

    suspend fun insertSeller(seller: Seller) {
        appDao.insertSeller(seller)
    }

    suspend fun updateSellerStatus(id: Int, status: String) {
        appDao.updateSellerStatus(id, status)
    }

    suspend fun updateSellerBanStatus(id: Int, isBanned: Boolean, banReason: String?) {
        appDao.updateSellerBanStatus(id, isBanned, banReason)
    }

    suspend fun deleteSeller(id: Int) {
        appDao.deleteSeller(id)
    }

    // Approval Requests
    val approvalRequests: Flow<List<ApprovalRequest>> = appDao.getApprovalRequests()

    suspend fun insertApprovalRequest(request: ApprovalRequest) {
        appDao.insertApprovalRequest(request)
    }

    suspend fun updateApprovalStatus(id: Int, status: String) {
        appDao.updateApprovalStatus(id, status)
    }

    // Notifications
    val notifications: Flow<List<Notification>> = appDao.getNotifications()

    suspend fun insertNotification(notification: Notification) {
        appDao.insertNotification(notification)
    }

    suspend fun markNotificationAsRead(id: Int) {
        appDao.markNotificationAsRead(id)
    }

    suspend fun markAllNotificationsAsRead() {
        appDao.markAllNotificationsAsRead()
    }

    // User Profile
    suspend fun getUserProfileDirect(username: String): UserProfile? {
        return appDao.getUserProfileDirect(username)
    }

    fun getUserProfile(username: String): Flow<UserProfile?> {
        return appDao.getUserProfile(username)
    }

    suspend fun insertUserProfile(profile: UserProfile) {
        appDao.insertUserProfile(profile)
    }
}
