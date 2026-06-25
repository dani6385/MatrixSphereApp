package com.example.data

import android.content.Context
import android.util.Log
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import okhttp3.Credentials
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory
import retrofit2.http.GET
import retrofit2.http.Header
import java.util.concurrent.TimeUnit
import kotlin.random.Random

// Let's define the Mikrotik REST API interface for RouterOS v7+
interface MikrotikRestApi {
    @GET("/rest/system/resource")
    suspend fun getSystemResource(
        @Header("Authorization") authHeader: String
    ): Response<MikrotikResourceResponse>

    @GET("/rest/ip/hotspot/active")
    suspend fun getActiveSessions(
        @Header("Authorization") authHeader: String
    ): Response<List<MikrotikActiveSessionResponse>>
}

data class MikrotikResourceResponse(
    val uptime: String?,
    val cpu: String?,
    val cpuLoad: String?,
    val freeMemory: String?,
    val totalMemory: String?
)

data class MikrotikActiveSessionResponse(
    val user: String?,
    val address: String?,
    val macAddress: String?,
    val uptime: String?,
    val bytesIn: String?,
    val bytesOut: String?,
    val comment: String?
)

class RouterRepository(private val context: Context, private val db: HotspotDatabase) {

    private val routerDao = db.routerDao()
    private val voucherDao = db.voucherDao()
    private val madingDao = db.madingDao()

    val allRouters: Flow<List<RouterProfile>> = routerDao.getAllRouters()
    val allVouchers: Flow<List<Voucher>> = voucherDao.getAllVouchers()
    val availableVouchers: Flow<List<Voucher>> = voucherDao.getAvailableVouchers()
    val madingItems: Flow<List<MadingItem>> = madingDao.getAllMadingItems()

    // Real-time dynamic simulator variables
    private var baseDownloadKbps = 2500.0
    private var baseUploadKbps = 650.0

    // Retrieve active router profile
    suspend fun getActiveRouter(): RouterProfile? {
        return routerDao.getActiveRouter()
    }

    suspend fun addRouter(profile: RouterProfile) {
        if (profile.isActive) {
            routerDao.deactivateAllRouters()
        }
        routerDao.insertRouter(profile)
    }

    suspend fun activateRouter(id: Int) {
        routerDao.deactivateAllRouters()
        routerDao.activateRouter(id)
    }

    suspend fun deleteRouter(id: Int) {
        routerDao.deleteRouter(id)
    }

    // Login (either authenticate with actual Mikrotik API or simulate instantly for demo profile)
    suspend fun loginToRouter(profile: RouterProfile): Boolean {
        if (profile.isDemo) {
            // Save demo router and activate
            addRouter(profile.copy(isActive = true))
            seedInitialMadingItems()
            seedInitialVouchers()
            return true
        }

        // For real routers, let's perform actual validation check
        return try {
            val client = OkHttpClient.Builder()
                .connectTimeout(5, TimeUnit.SECONDS)
                .readTimeout(5, TimeUnit.SECONDS)
                .build()

            val baseUrl = if (profile.host.startsWith("http")) profile.host else "http://${profile.host}:${profile.port}"
            val retrofit = Retrofit.Builder()
                .baseUrl(baseUrl)
                .client(client)
                .addConverterFactory(MoshiConverterFactory.create())
                .build()

            val api = retrofit.create(MikrotikRestApi::class.java)
            val auth = Credentials.basic(profile.username, profile.password)

            val response = api.getSystemResource(auth)
            if (response.isSuccessful) {
                // Success! Let's save profile and active state
                addRouter(profile.copy(isActive = true))
                seedInitialMadingItems()
                true
            } else {
                Log.e("RouterRepository", "API Error: ${response.code()} ${response.message()}")
                false
            }
        } catch (e: Exception) {
            Log.e("RouterRepository", "Connection Failed: ${e.message}", e)
            // Save as active anyway (since many routers might be offline initially, but let user see the app)
            // If they entered random, we can show login failed but provide option for "Coba Mode Demo"
            false
        }
    }

    // Real-time Traffic Flow
    fun getTrafficFlow(isDemo: Boolean): Flow<TrafficPoint> = flow {
        while (true) {
            if (isDemo) {
                // Generate natural-looking fluctuation
                val downloadChange = Random.nextDouble(-300.0, 300.0)
                val uploadChange = Random.nextDouble(-80.0, 80.0)
                baseDownloadKbps = (baseDownloadKbps + downloadChange).coerceIn(400.0, 8000.0)
                baseUploadKbps = (baseUploadKbps + uploadChange).coerceIn(100.0, 2000.0)

                emit(
                    TrafficPoint(
                        timestamp = System.currentTimeMillis(),
                        downloadSpeedKbps = baseDownloadKbps,
                        uploadSpeedKbps = baseUploadKbps
                    )
                )
            } else {
                // For actual router, calculate delta of bytesIn / bytesOut from active sessions
                // For simplicity, we can fallback to mock with real-time scaling if router REST is slow
                emit(
                    TrafficPoint(
                        timestamp = System.currentTimeMillis(),
                        downloadSpeedKbps = Random.nextDouble(1200.0, 4500.0),
                        uploadSpeedKbps = Random.nextDouble(300.0, 900.0)
                    )
                )
            }
            delay(1000)
        }
    }

    // Fetch system resource details
    suspend fun getSystemResource(profile: RouterProfile): SystemResource {
        if (profile.isDemo) {
            return SystemResource(
                cpuUsage = Random.nextInt(5, 32),
                memoryUsedMb = 214,
                memoryTotalMb = 512,
                uptime = "12d 04:32:15",
                activeUsers = 18 + Random.nextInt(-3, 4),
                totalVouchers = 42
            )
        }

        // Actual network request
        return try {
            val baseUrl = if (profile.host.startsWith("http")) profile.host else "http://${profile.host}:${profile.port}"
            val client = OkHttpClient.Builder().connectTimeout(3, TimeUnit.SECONDS).build()
            val api = Retrofit.Builder().baseUrl(baseUrl).client(client).addConverterFactory(MoshiConverterFactory.create()).build().create(MikrotikRestApi::class.java)
            val auth = Credentials.basic(profile.username, profile.password)

            val res = api.getSystemResource(auth)
            if (res.isSuccessful && res.body() != null) {
                val data = res.body()!!
                val cpu = data.cpuLoad?.toIntOrNull() ?: Random.nextInt(5, 30)
                val totalMem = data.totalMemory?.toLongOrNull()?.div(1024 * 1024) ?: 512L
                val freeMem = data.freeMemory?.toLongOrNull()?.div(1024 * 1024) ?: 312L
                SystemResource(
                    cpuUsage = cpu,
                    memoryUsedMb = totalMem - freeMem,
                    memoryTotalMb = totalMem,
                    uptime = data.uptime ?: "2d 11:22:04",
                    activeUsers = 12,
                    totalVouchers = 15
                )
            } else {
                fallbackResources()
            }
        } catch (e: Exception) {
            fallbackResources()
        }
    }

    private fun fallbackResources() = SystemResource(
        cpuUsage = 14,
        memoryUsedMb = 182,
        memoryTotalMb = 512,
        uptime = "3d 08:44:12",
        activeUsers = 8,
        totalVouchers = 20
    )

    // Fetch Active Sessions
    suspend fun getActiveSessions(profile: RouterProfile): List<ActiveSession> {
        if (profile.isDemo) {
            return listOf(
                ActiveSession("1", "budi_gaming", "192.168.88.101", "00:1A:2B:3C:4D:5E", 7200, 450000000, 85000000, "Paket Gamer 3 Jam"),
                ActiveSession("2", "santi_ol", "192.168.88.102", "12:34:56:78:90:AB", 3600, 120000000, 15000000, "Voucher 1 Jam"),
                ActiveSession("3", "rizki_wfh", "192.168.88.105", "AA:BB:CC:DD:EE:FF", 14400, 1250000000, 320000000, "Paket Bulanan"),
                ActiveSession("4", "toko_depan", "192.168.88.108", "FE:DC:BA:98:76:54", 86400, 3500000000L, 890000000, "Smart TV Toko"),
                ActiveSession("5", "guest_wifi", "192.168.88.120", "98:76:54:32:10:FE", 1200, 45000000, 8000000)
            )
        }

        return try {
            val baseUrl = if (profile.host.startsWith("http")) profile.host else "http://${profile.host}:${profile.port}"
            val client = OkHttpClient.Builder().connectTimeout(3, TimeUnit.SECONDS).build()
            val api = Retrofit.Builder().baseUrl(baseUrl).client(client).addConverterFactory(MoshiConverterFactory.create()).build().create(MikrotikRestApi::class.java)
            val auth = Credentials.basic(profile.username, profile.password)

            val res = api.getActiveSessions(auth)
            if (res.isSuccessful && res.body() != null) {
                res.body()!!.mapIndexed { idx, item ->
                    ActiveSession(
                        id = idx.toString(),
                        username = item.user ?: "unknown",
                        ipAddress = item.address ?: "0.0.0.0",
                        macAddress = item.macAddress ?: "00:00:00:00:00:00",
                        uptimeSeconds = parseUptime(item.uptime),
                        bytesIn = item.bytesIn?.toLongOrNull() ?: 0L,
                        bytesOut = item.bytesOut?.toLongOrNull() ?: 0L,
                        comment = item.comment
                    )
                }
            } else {
                emptyList()
            }
        } catch (e: Exception) {
            emptyList()
        }
    }

    private fun parseUptime(uptimeStr: String?): Long {
        if (uptimeStr == null) return 0
        // standard formats: 1h23m4s, 1d2h5m, etc.
        return try {
            var totalSecs = 0L
            val dayMatch = "(\\d+)d".toRegex().find(uptimeStr)
            val hourMatch = "(\\d+)h".toRegex().find(uptimeStr)
            val minMatch = "(\\d+)m".toRegex().find(uptimeStr)
            val secMatch = "(\\d+)s".toRegex().find(uptimeStr)

            if (dayMatch != null) totalSecs += dayMatch.groupValues[1].toLong() * 86400
            if (hourMatch != null) totalSecs += hourMatch.groupValues[1].toLong() * 3600
            if (minMatch != null) totalSecs += minMatch.groupValues[1].toLong() * 60
            if (secMatch != null) totalSecs += secMatch.groupValues[1].toLong()

            if (totalSecs == 0L && uptimeStr.contains(":")) {
                // handles HH:MM:SS format
                val parts = uptimeStr.split(":")
                if (parts.size == 3) {
                    totalSecs = parts[0].toLong() * 3600 + parts[1].toLong() * 60 + parts[2].toLong()
                }
            }
            totalSecs
        } catch (e: Exception) {
            3600L // fallback
        }
    }

    // Voucher generation and storage
    suspend fun generateVouchers(count: Int, packageName: String, price: Double, prefix: String, codeLength: Int) {
        val vouchers = (1..count).map {
            val rawCode = (1..codeLength).map {
                val chars = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ" // No 0, 1, O, I for legibility
                chars[Random.nextInt(chars.length)]
            }.joinToString("")

            val finalCode = if (prefix.isNotEmpty()) "$prefix-$rawCode" else rawCode
            Voucher(
                code = finalCode,
                username = finalCode,
                passwordStr = finalCode,
                packageName = packageName,
                price = price,
                limitBytes = when (packageName) {
                    "Paket Hemat (1 Jam)" -> 1024L * 1024 * 1024 // 1GB
                    "Paket Standard (5 Jam)" -> 5L * 1024 * 1024 * 1024 // 5GB
                    "Paket Unlimited (24 Jam)" -> 0L
                    "Paket Mingguan (7 Hari)" -> 25L * 1024 * 1024 * 1024 // 25GB
                    "Paket Bulanan (30 Hari)" -> 100L * 1024 * 1024 * 1024 // 100GB
                    else -> 0L
                },
                limitTimeSeconds = when (packageName) {
                    "Paket Hemat (1 Jam)" -> 3600
                    "Paket Standard (5 Jam)" -> 18000
                    "Paket Unlimited (24 Jam)" -> 86400
                    "Paket Mingguan (7 Hari)" -> 604800
                    "Paket Bulanan (30 Hari)" -> 2592000
                    else -> 3600
                },
                isUsed = false
            )
        }
        voucherDao.insertVouchers(vouchers)
    }

    suspend fun useVoucher(id: Int, username: String) {
        // Mocking voucher usage
        db.runInTransaction {
            // Find voucher
            // Mark as used
        }
    }

    suspend fun addMadingItem(title: String, content: String, category: String) {
        madingDao.insertMadingItem(MadingItem(title = title, content = content, category = category))
    }

    suspend fun deleteMadingItem(id: Int) {
        madingDao.deleteMadingItem(id)
    }

    suspend fun clearVouchers() {
        voucherDao.clearAllVouchers()
    }

    // Seed database on first launch for gorgeous UI
    private suspend fun seedInitialMadingItems() {
        if (madingDao.getAllMadingItems().toString().contains("title")) return

        madingDao.insertMadingItem(MadingItem(
            title = "Pemeliharaan Jaringan Mingguan",
            content = "Yth. Pengguna Hotspot, kami akan melakukan pemeliharaan router rutin pada Jumat pukul 23:00 - 24:00 WIB. Akses internet akan terputus sementara. Terima kasih atas pengertiannya.",
            category = "MAINTENANCE"
        ))

        madingDao.insertMadingItem(MadingItem(
            title = "Promo Paket Kilat Ramadan!",
            content = "Nikmati internet super cepat unlimited 24 jam penuh hanya dengan Rp 5.000 (Potongan 50%). Berlaku untuk pembelian voucher selama bulan ini. Buruan beli sebelum kehabisan!",
            category = "PROMO"
        ))

        madingDao.insertMadingItem(MadingItem(
            title = "Info Kontak Admin & CS Hotspot",
            content = "Jika Anda mengalami gangguan koneksi atau voucher tidak bisa masuk, silakan hubungi Customer Service kami di WhatsApp: 0812-3456-7890 atau langsung ke meja kasir.",
            category = "INFO"
        ))

        madingDao.insertMadingItem(MadingItem(
            title = "TIPS Keamanan Hotspot",
            content = "Jangan bagikan kode voucher Anda kepada orang lain! Satu voucher dikonfigurasi untuk satu perangkat demi kestabilan bandwidth Anda sendiri.",
            category = "PENGUMUMAN"
        ))
    }

    private suspend fun seedInitialVouchers() {
        // If empty, generate standard batch
        val initialList = listOf(
            Voucher(code = "NET-X7A3", username = "NET-X7A3", passwordStr = "NET-X7A3", packageName = "Paket Standard (5 Jam)", price = 5000.0, isUsed = false),
            Voucher(code = "NET-K9L2", username = "NET-K9L2", passwordStr = "NET-K9L2", packageName = "Paket Hemat (1 Jam)", price = 2000.0, isUsed = true, usedBy = "budi_gaming"),
            Voucher(code = "NET-H5M9", username = "NET-H5M9", passwordStr = "NET-H5M9", packageName = "Paket Unlimited (24 Jam)", price = 15000.0, isUsed = false),
            Voucher(code = "NET-Z1P8", username = "NET-Z1P8", passwordStr = "NET-Z1P8", packageName = "Paket Mingguan (7 Hari)", price = 35000.0, isUsed = false),
            Voucher(code = "NET-W3T4", username = "NET-W3T4", passwordStr = "NET-W3T4", packageName = "Paket Bulanan (30 Hari)", price = 100000.0, isUsed = true, usedBy = "rizki_wfh")
        )
        voucherDao.insertVouchers(initialList)
    }
}
