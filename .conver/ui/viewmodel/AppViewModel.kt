package com.example.ui.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.example.data.model.*
import com.example.data.repository.AppRepository
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import kotlin.random.Random

class AppViewModel(private val repository: AppRepository) : ViewModel() {

    // Auth States
    private val _isLoggedIn = MutableStateFlow(false)
    val isLoggedIn: StateFlow<Boolean> = _isLoggedIn.asStateFlow()

    private val _currentUser = MutableStateFlow<UserProfile?>(null)
    val currentUser: StateFlow<UserProfile?> = _currentUser.asStateFlow()

    private val _loginStep = MutableStateFlow(LoginStep.LOGIN_SELECTION)
    val loginStep: StateFlow<LoginStep> = _loginStep.asStateFlow()

    private val _twoFactorCode = MutableStateFlow("")
    val twoFactorCode: StateFlow<String> = _twoFactorCode.asStateFlow()

    // UI Message state for toast/dialogs
    private val _authError = MutableStateFlow<String?>(null)
    val authError: StateFlow<String?> = _authError.asStateFlow()

    private val _profileSuccessMessage = MutableStateFlow<String?>(null)
    val profileSuccessMessage: StateFlow<String?> = _profileSuccessMessage.asStateFlow()

    // Database Flows
    val appAccessList: StateFlow<List<AppAccess>> = repository.appAccessList
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    val sellers: StateFlow<List<Seller>> = repository.sellers
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    val approvalRequests: StateFlow<List<ApprovalRequest>> = repository.approvalRequests
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    val notifications: StateFlow<List<Notification>> = repository.notifications
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    // UI Search and Filter States for Seller Screen
    private val _sellerSearchQuery = MutableStateFlow("")
    val sellerSearchQuery: StateFlow<String> = _sellerSearchQuery.asStateFlow()

    private val _sellerFilterStatus = MutableStateFlow("Semua") // "Semua", "Aktif", "Tidak Aktif"
    val sellerFilterStatus: StateFlow<String> = _sellerFilterStatus.asStateFlow()

    init {
        // Pre-populate Database with beautiful initial data if empty
        viewModelScope.launch {
            // Setup default profile
            val existingAdmin = repository.getUserProfileDirect("admin")
            if (existingAdmin == null) {
                val defaultAdmin = UserProfile(
                    username = "admin",
                    fullName = "Administrator Utama",
                    email = "admin@securapp.com",
                    phone = "+628123456789",
                    passwordHash = "admin",
                    isTwoFactorEnabled = true // Pre-enable 2FA to showcase the full flow requested
                )
                repository.insertUserProfile(defaultAdmin)
                _currentUser.value = defaultAdmin
            } else {
                _currentUser.value = existingAdmin
            }

            // Setup default monitored apps
            repository.appAccessList.first().let { list ->
                if (list.isEmpty()) {
                    val apps = listOf(
                        AppAccess("com.google.android.youtube", "YouTube", 120, false, "Sosial & Video", 90),
                        AppAccess("com.zhiliaoapp.musically", "TikTok", 240, true, "Sosial & Video", 60),
                        AppAccess("com.mobile.legends", "Mobile Legends", 180, false, "Game", 120),
                        AppAccess("com.whatsapp", "WhatsApp", 95, false, "Komunikasi", 180),
                        AppAccess("com.instagram.android", "Instagram", 150, false, "Sosial & Video", 90),
                        AppAccess("com.facebook.katana", "Facebook", 45, false, "Sosial & Video", 120),
                        AppAccess("com.tencent.ig", "PUBG Mobile", 110, true, "Game", 60),
                        AppAccess("com.spotify.music", "Spotify", 75, false, "Hiburan & Musik", 240),
                        AppAccess("com.discord", "Discord", 60, false, "Komunikasi", 120)
                    )
                    apps.forEach { repository.insertAppAccess(it) }
                }
            }

            // Setup default sellers
            repository.sellers.first().let { list ->
                if (list.isEmpty()) {
                    val sellersList = listOf(
                        Seller(name = "Budi Santoso", email = "budi.santoso@gmail.com", storeName = "Budi Tech", status = "Aktif", contact = "08129876543", isBanned = false),
                        Seller(name = "Susi Susanti", email = "susi.susanti@gmail.com", storeName = "Susi Fashion", status = "Aktif", contact = "08561234567", isBanned = false),
                        Seller(name = "Ahmad Fauzi", email = "ahmad.fauzi@yahoo.com", storeName = "Fauzi Fresh", status = "Tidak Aktif", contact = "08138888999", isBanned = false),
                        Seller(name = "Rini Lestari", email = "rini.lestari@gmail.com", storeName = "Lestari Craft", status = "Aktif", contact = "08215555444", isBanned = true, banReason = "Pelanggaran Ketentuan Transaksi (Spamming)"),
                        Seller(name = "Dewi Pratama", email = "dewi.pratama@outlook.com", storeName = "Dewi Books", status = "Tidak Aktif", contact = "08772222111", isBanned = false),
                        Seller(name = "Joko Widodo", email = "joko.wi@gmail.com", storeName = "Solo Mebel", status = "Aktif", contact = "08112233445", isBanned = true, banReason = "Penggunaan Bot Akses Tanpa Izin")
                    )
                    sellersList.forEach { repository.insertSeller(it) }
                }
            }

            // Setup default approval requests
            repository.approvalRequests.first().let { list ->
                if (list.isEmpty()) {
                    val requests = listOf(
                        ApprovalRequest(title = "Pendaftaran Seller Baru", details = "Pendaftaran toko 'Harapan Jaya' oleh seller Rudi Hermawan. Verifikasi dokumen lengkap.", requesterName = "Rudi Hermawan", status = "Menunggu"),
                        ApprovalRequest(title = "Permintaan Buka Blokir", details = "Seller 'Rini Lestari' meminta pemulihan akun setelah menyelesaikan klarifikasi banding.", requesterName = "Rini Lestari", status = "Menunggu"),
                        ApprovalRequest(title = "Akses API Eksternal", details = "Permintaan integrasi webhook transaksi dari Seller 'Susi Fashion' untuk platform ERP.", requesterName = "Susi Susanti", status = "Menunggu"),
                        ApprovalRequest(title = "Pendaftaran Seller Baru", details = "Pendaftaran toko 'Berkah Tani' oleh seller Slamet Mulya.", requesterName = "Slamet Mulya", status = "Disetujui"),
                        ApprovalRequest(title = "Izin Modifikasi Profil", details = "Permintaan penggantian nomor rekening utama bank milik toko 'Budi Tech'.", requesterName = "Budi Santoso", status = "Ditolak")
                    )
                    requests.forEach { repository.insertApprovalRequest(it) }
                }
            }

            // Setup default notifications
            repository.notifications.first().let { list ->
                if (list.isEmpty()) {
                    val defaultNotifications = listOf(
                        Notification(message = "Seller Budi Santoso melakukan login dari IP baru.", isRead = false),
                        Notification(message = "Permintaan persetujuan baru dari Rudi Hermawan diterima.", isRead = false),
                        Notification(message = "Sistem memblokir otomatis aplikasi TikTok karena batas waktu habis.", isRead = true)
                    )
                    defaultNotifications.forEach { repository.insertNotification(it) }
                }
            }
        }
    }

    // Google Login process simulation
    fun selectGoogleAccount(email: String) {
        viewModelScope.launch {
            _loginStep.value = LoginStep.VERIFYING
            // Simulate brief network delay
            kotlinx.coroutines.delay(1000)

            // Find or create profile matching this google email
            val username = email.substringBefore("@")
            val existing = repository.getUserProfileDirect(username)
            val profile = if (existing != null) {
                existing
            } else {
                val newProfile = UserProfile(
                    username = username,
                    fullName = username.replaceFirstChar { it.uppercase() } + " (Google)",
                    email = email,
                    phone = "+62812" + Random.nextInt(10000000, 99999999),
                    passwordHash = "google_oauth_token",
                    isTwoFactorEnabled = true // Enable 2FA mock by default for google account as well
                )
                repository.insertUserProfile(newProfile)
                newProfile
            }

            _currentUser.value = profile

            if (profile.isTwoFactorEnabled) {
                // Generate and send code
                val code = (100000 + Random.nextInt(900000)).toString()
                _twoFactorCode.value = code
                _loginStep.value = LoginStep.TWO_FACTOR
                
                // Add a dynamic notification containing the verification code so the user knows what to enter
                repository.insertNotification(
                    Notification(message = "[OTP SECURE] Kode verifikasi Anda adalah $code. Berlaku selama 5 menit.", isRead = false)
                )
            } else {
                _isLoggedIn.value = true
                _loginStep.value = LoginStep.LOGGED_IN
                repository.insertNotification(
                    Notification(message = "Admin ${profile.fullName} berhasil masuk menggunakan Google Auth.", isRead = false)
                )
            }
        }
    }

    // Traditional Username & Password Login
    fun performTraditionalLogin(usernameInput: String, passwordInput: String) {
        viewModelScope.launch {
            _loginStep.value = LoginStep.VERIFYING
            kotlinx.coroutines.delay(1200)

            val profile = repository.getUserProfileDirect(usernameInput)
            if (profile != null && profile.passwordHash == passwordInput) {
                _currentUser.value = profile
                _authError.value = null

                if (profile.isTwoFactorEnabled) {
                    val code = (100000 + Random.nextInt(900000)).toString()
                    _twoFactorCode.value = code
                    _loginStep.value = LoginStep.TWO_FACTOR

                    repository.insertNotification(
                        Notification(message = "[OTP SECURE] Kode verifikasi login adalah $code. Silakan masukkan di layar verifikasi.", isRead = false)
                    )
                } else {
                    _isLoggedIn.value = true
                    _loginStep.value = LoginStep.LOGGED_IN
                    repository.insertNotification(
                        Notification(message = "Admin ${profile.fullName} berhasil masuk.", isRead = false)
                    )
                }
            } else {
                _authError.value = "Username atau kata sandi salah!"
                _loginStep.value = LoginStep.LOGIN_SELECTION
            }
        }
    }

    // Two Factor Verification Code Check
    fun verifyOtp(enteredCode: String): Boolean {
        return if (enteredCode == _twoFactorCode.value) {
            _isLoggedIn.value = true
            _loginStep.value = LoginStep.LOGGED_IN
            _authError.value = null
            
            viewModelScope.launch {
                repository.insertNotification(
                    Notification(message = "Otentikasi dua langkah sukses. Admin ${_currentUser.value?.fullName ?: ""} masuk.", isRead = false)
                )
            }
            true
        } else {
            _authError.value = "Kode verifikasi (OTP) tidak valid!"
            false
        }
    }

    // Trigger explicit Google Auth Selection UI state
    fun initiateGoogleLogin() {
        _loginStep.value = LoginStep.GOOGLE_SELECT
    }

    // Cancel / Go Back to Auth Choice
    fun resetLoginFlow() {
        _loginStep.value = LoginStep.LOGIN_SELECTION
        _authError.value = null
    }

    fun logout() {
        _isLoggedIn.value = false
        _loginStep.value = LoginStep.LOGIN_SELECTION
        _currentUser.value = null
        _twoFactorCode.value = ""
    }

    // App Control Management Actions
    fun toggleAppBlock(packageName: String, isBlocked: Boolean) {
        viewModelScope.launch {
            repository.updateAppAccessBlockStatus(packageName, isBlocked)
            val app = appAccessList.value.find { it.packageName == packageName }
            val appName = app?.appName ?: packageName
            val action = if (isBlocked) "memblokir" else "membuka blokir"
            
            repository.insertNotification(
                Notification(message = "Admin secara manual $action akses aplikasi $appName.", isRead = false)
            )
        }
    }

    fun addAppToMonitor(appName: String, packageName: String, category: String, limit: Int) {
        viewModelScope.launch {
            val app = AppAccess(packageName, appName, 0, false, category, limit)
            repository.insertAppAccess(app)
            repository.insertNotification(
                Notification(message = "Aplikasi baru $appName ($packageName) ditambahkan ke daftar pantauan.", isRead = false)
            )
        }
    }

    // Seller Screen Actions
    fun setSellerSearchQuery(query: String) {
        _sellerSearchQuery.value = query
    }

    fun setSellerFilterStatus(status: String) {
        _sellerFilterStatus.value = status
    }

    fun addNewSeller(name: String, storeName: String, email: String, contact: String) {
        viewModelScope.launch {
            val seller = Seller(
                name = name,
                email = email,
                storeName = storeName,
                status = "Aktif",
                contact = contact
            )
            repository.insertSeller(seller)
            
            // Trigger a real-time notification
            repository.insertNotification(
                Notification(message = "Seller Baru Terdaftar: $name mendaftarkan toko '$storeName'!", isRead = false)
            )
        }
    }

    fun banSeller(id: Int, reason: String) {
        viewModelScope.launch {
            val seller = sellers.value.find { it.id == id }
            if (seller != null) {
                repository.updateSellerBanStatus(id, true, reason)
                repository.updateSellerStatus(id, "Tidak Aktif")
                repository.insertNotification(
                    Notification(message = "AKUN DIBANNED: Toko '${seller.storeName}' ditangguhkan karena $reason.", isRead = false)
                )
            }
        }
    }

    fun unbanSeller(id: Int) {
        viewModelScope.launch {
            val seller = sellers.value.find { it.id == id }
            if (seller != null) {
                repository.updateSellerBanStatus(id, false, null)
                repository.updateSellerStatus(id, "Aktif")
                repository.insertNotification(
                    Notification(message = "AKUN DIPULIHKAN: Blokir toko '${seller.storeName}' telah dicabut admin.", isRead = false)
                )
            }
        }
    }

    fun deleteSeller(id: Int) {
        viewModelScope.launch {
            val seller = sellers.value.find { it.id == id }
            if (seller != null) {
                repository.deleteSeller(id)
                repository.insertNotification(
                    Notification(message = "Seller '${seller.name}' dihapus permanen dari sistem.", isRead = false)
                )
            }
        }
    }

    // Real-Time Notification Generator (Simulating seller activity as requested)
    fun simulateRandomSellerActivity() {
        viewModelScope.launch {
            val activeSellers = sellers.value.filter { !it.isBanned && it.status == "Aktif" }
            if (activeSellers.isNotEmpty()) {
                val randomSeller = activeSellers[Random.nextInt(activeSellers.size)]
                val activities = listOf(
                    "membuat etalase produk diskon baru",
                    "memperbarui stok barang di tokonya",
                    "memproses pesanan yang tertunda",
                    "mengirimkan pesan siaran promosi ke pelanggan",
                    "mengubah pengaturan jam operasional toko"
                )
                val action = activities[Random.nextInt(activities.size)]
                val msg = "Seller '${randomSeller.name}' (${randomSeller.storeName}) sedang $action."
                
                repository.insertNotification(Notification(message = msg, isRead = false))
            } else {
                repository.insertNotification(
                    Notification(message = "Seller tamu memicu aktivitas: memperbarui katalog sistem.", isRead = false)
                )
            }
        }
    }

    // Approval Screen Actions
    fun approveRequest(id: Int) {
        viewModelScope.launch {
            val request = approvalRequests.value.find { it.id == id }
            if (request != null) {
                repository.updateApprovalStatus(id, "Disetujui")
                repository.insertNotification(
                    Notification(message = "PERSETUJUAN: Permintaan '${request.title}' oleh ${request.requesterName} DISETUJUI admin.", isRead = false)
                )

                // If it's a seller registration, make sure they are added/activated
                if (request.title == "Pendaftaran Seller Baru") {
                    // Try to add as a real seller
                    val storeName = request.details.substringAfter("toko '").substringBefore("'")
                    val hasExisting = sellers.value.any { it.storeName == storeName }
                    if (!hasExisting) {
                        repository.insertSeller(
                            Seller(
                                name = request.requesterName,
                                email = "${request.requesterName.lowercase().replace(" ", "")}@gmail.com",
                                storeName = storeName,
                                status = "Aktif",
                                contact = "0812" + Random.nextInt(1000000, 9999999)
                            )
                        )
                    }
                }
            }
        }
    }

    fun rejectRequest(id: Int) {
        viewModelScope.launch {
            val request = approvalRequests.value.find { it.id == id }
            if (request != null) {
                repository.updateApprovalStatus(id, "Ditolak")
                repository.insertNotification(
                    Notification(message = "PERSETUJUAN: Permintaan '${request.title}' oleh ${request.requesterName} DITOLAK admin.", isRead = false)
                )
            }
        }
    }

    // Notification Actions
    fun dismissNotification(id: Int) {
        viewModelScope.launch {
            repository.markNotificationAsRead(id)
        }
    }

    fun markAllNotificationsAsRead() {
        viewModelScope.launch {
            repository.markAllNotificationsAsRead()
        }
    }

    // User Settings Actions
    fun updateContactInformation(fullName: String, email: String, phone: String) {
        viewModelScope.launch {
            val current = _currentUser.value
            if (current != null) {
                val updated = current.copy(
                    fullName = fullName,
                    email = email,
                    phone = phone
                )
                repository.insertUserProfile(updated)
                _currentUser.value = updated
                _profileSuccessMessage.value = "Informasi kontak berhasil diperbarui!"
                
                repository.insertNotification(
                    Notification(message = "Admin memperbarui informasi kontak profil.", isRead = false)
                )
            }
        }
    }

    fun updatePassword(password: String) {
        viewModelScope.launch {
            val current = _currentUser.value
            if (current != null) {
                val updated = current.copy(passwordHash = password)
                repository.insertUserProfile(updated)
                _currentUser.value = updated
                _profileSuccessMessage.value = "Kata sandi berhasil diperbarui!"

                repository.insertNotification(
                    Notification(message = "Admin berhasil mengubah kata sandi utama.", isRead = false)
                )
            }
        }
    }

    fun toggle2FA(enabled: Boolean) {
        viewModelScope.launch {
            val current = _currentUser.value
            if (current != null) {
                val updated = current.copy(isTwoFactorEnabled = enabled)
                repository.insertUserProfile(updated)
                _currentUser.value = updated
                val statusText = if (enabled) "diaktifkan" else "dinonaktifkan"
                _profileSuccessMessage.value = "Verifikasi 2 langkah $statusText!"

                repository.insertNotification(
                    Notification(message = "Pengaturan keamanan: Verifikasi Dua Langkah (2FA) $statusText.", isRead = false)
                )
            }
        }
    }

    fun clearProfileMessage() {
        _profileSuccessMessage.value = null
    }

    fun clearAuthError() {
        _authError.value = null
    }
}

enum class LoginStep {
    LOGIN_SELECTION,
    GOOGLE_SELECT,
    VERIFYING,
    TWO_FACTOR,
    LOGGED_IN
}

class AppViewModelFactory(private val repository: AppRepository) : ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(AppViewModel::class.java)) {
            @Suppress("UNCHECKED_CAST")
            return AppViewModel(repository) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}
