package com.example.ui

import android.app.Application
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.example.data.ActiveSession
import com.example.data.HotspotDatabase
import com.example.data.MadingItem
import com.example.data.RouterProfile
import com.example.data.RouterRepository
import com.example.data.SystemResource
import com.example.data.TrafficPoint
import com.example.data.Voucher
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

enum class AppScreen {
    Login,
    Home,
    Status,
    Transaksi,
    Akun,
    Settings
}

class HotspotViewModel(application: Application) : AndroidViewModel(application) {

    private val db = HotspotDatabase.getDatabase(application)
    private val repository = RouterRepository(application, db)

    // Current Navigation State
    var currentScreen by mutableStateOf(AppScreen.Login)
        private set

    // Active connection state
    var activeRouter by mutableStateOf<RouterProfile?>(null)
        private set

    var connectionStatus by mutableStateOf("DISCONNECTED") // CONNECTED, CONNECTING, DISCONNECTED, ERROR
        private set

    var loginError by mutableStateOf<String?>(null)
        private set

    // System metrics
    var systemResource by mutableStateOf<SystemResource?>(null)
        private set

    var activeSessions by mutableStateOf<List<ActiveSession>>(emptyList())
        private set

    private val _trafficHistory = MutableStateFlow<List<TrafficPoint>>(emptyList())
    val trafficHistory: StateFlow<List<TrafficPoint>> = _trafficHistory.asStateFlow()

    // Database flow streams
    val allRouters: StateFlow<List<RouterProfile>> = repository.allRouters
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    val vouchers: StateFlow<List<Voucher>> = repository.allVouchers
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    val availableVouchers: StateFlow<List<Voucher>> = repository.availableVouchers
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    val madingItems: StateFlow<List<MadingItem>> = repository.madingItems
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    // Active user session countdown & notification states (Simulasi pengguna hotspot aktif)
    var currentUserActive by mutableStateOf(true)
    var currentUserTimeLeftSeconds by mutableStateOf(615L) // Starts at 10m 15s to quickly trigger warning under 10m!
    var showActivePeriodNotification by mutableStateOf(false)
    var isNotificationDismissed by mutableStateOf(false)

    // Background observation jobs
    private var trafficJob: Job? = null
    private var statsJob: Job? = null
    private var countdownJob: Job? = null

    init {
        viewModelScope.launch {
            // Check for pre-existing active router
            val router = repository.getActiveRouter()
            if (router != null) {
                activeRouter = router
                connectionStatus = "CONNECTED"
                currentScreen = AppScreen.Home
                startMonitoring(router)
            }
        }
        startUserCountdown()
    }

    fun navigateTo(screen: AppScreen) {
        currentScreen = screen
    }

    // Connect / Login to Router
    fun login(host: String, port: String, user: String, pass: String, alias: String, isDemo: Boolean) {
        viewModelScope.launch {
            connectionStatus = "CONNECTING"
            loginError = null

            val parsedPort = port.toIntOrNull() ?: 8728
            val profile = RouterProfile(
                host = host,
                port = parsedPort,
                username = user,
                password = pass,
                aliasName = alias.ifEmpty { if (isDemo) "Router Demo" else host },
                isDemo = isDemo
            )

            val success = repository.loginToRouter(profile)
            if (success) {
                activeRouter = repository.getActiveRouter()
                connectionStatus = "CONNECTED"
                currentScreen = AppScreen.Home
                activeRouter?.let { startMonitoring(it) }
            } else {
                connectionStatus = "ERROR"
                loginError = "Gagal menghubungkan ke Router. Periksa alamat host, port, username, password, dan pastikan API Mikrotik aktif."
            }
        }
    }

    // Disconnect / Logout
    fun logout() {
        viewModelScope.launch {
            stopMonitoring()
            val active = activeRouter
            if (active != null) {
                repository.addRouter(active.copy(isActive = false))
            }
            activeRouter = null
            connectionStatus = "DISCONNECTED"
            currentScreen = AppScreen.Login
        }
    }

    // Voucher generation
    fun generateVouchers(count: Int, packageName: String, price: Double, prefix: String, codeLength: Int) {
        viewModelScope.launch {
            repository.generateVouchers(count, packageName, price, prefix, codeLength)
        }
    }

    // Voucher deletion
    fun deleteVoucher(id: Int) {
        viewModelScope.launch {
            // we don't have deleteVoucher direct mapping in repo, let's call database directly or repo
            db.voucherDao().deleteVoucher(id)
        }
    }

    // Mading items management
    fun addMadingItem(title: String, content: String, category: String) {
        viewModelScope.launch {
            repository.addMadingItem(title, content, category)
        }
    }

    fun deleteMadingItem(id: Int) {
        viewModelScope.launch {
            repository.deleteMadingItem(id)
        }
    }

    fun clearAllVouchers() {
        viewModelScope.launch {
            repository.clearVouchers()
        }
    }

    // Monitoring handlers
    private fun startMonitoring(profile: RouterProfile) {
        stopMonitoring()

        // Start real-time traffic monitoring flow
        trafficJob = viewModelScope.launch {
            repository.getTrafficFlow(profile.isDemo).collect { point ->
                val currentList = _trafficHistory.value.toMutableList()
                currentList.add(point)
                if (currentList.size > 25) {
                    currentList.removeAt(0)
                }
                _trafficHistory.value = currentList
            }
        }

        // Start periodic system specs & active user fetch job (every 3 seconds)
        statsJob = viewModelScope.launch {
            while (true) {
                systemResource = repository.getSystemResource(profile)
                activeSessions = repository.getActiveSessions(profile)
                kotlinx.coroutines.delay(3000)
            }
        }
    }

    private fun stopMonitoring() {
        trafficJob?.cancel()
        statsJob?.cancel()
        _trafficHistory.value = emptyList()
    }

    // Current user's connection countdown and notification simulation
    private fun startUserCountdown() {
        countdownJob?.cancel()
        countdownJob = viewModelScope.launch {
            while (true) {
                kotlinx.coroutines.delay(1000)
                if (currentUserActive && currentUserTimeLeftSeconds > 0) {
                    currentUserTimeLeftSeconds--

                    // If remaining active time is under 10 minutes (600s), show alert
                    if (currentUserTimeLeftSeconds <= 600 && !isNotificationDismissed) {
                        showActivePeriodNotification = true
                    } else {
                        showActivePeriodNotification = false
                    }
                }
            }
        }
    }

    fun resetCountdown() {
        currentUserTimeLeftSeconds = 3600 // Reset to 1 hour
        isNotificationDismissed = false
        showActivePeriodNotification = false
    }

    fun dismissNotificationBanner() {
        isNotificationDismissed = true
        showActivePeriodNotification = false
    }

    override fun onCleared() {
        super.onCleared()
        stopMonitoring()
        countdownJob?.cancel()
    }
}
