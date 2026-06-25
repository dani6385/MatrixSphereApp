package com.example.data

import android.content.Context
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.Update
import kotlinx.coroutines.flow.Flow

@Dao
interface RouterDao {
    @Query("SELECT * FROM router_profiles ORDER BY id DESC")
    fun getAllRouters(): Flow<List<RouterProfile>>

    @Query("SELECT * FROM router_profiles WHERE isActive = 1 LIMIT 1")
    suspend fun getActiveRouter(): RouterProfile?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertRouter(router: RouterProfile)

    @Update
    suspend fun updateRouter(router: RouterProfile)

    @Query("UPDATE router_profiles SET isActive = 0")
    suspend fun deactivateAllRouters()

    @Query("UPDATE router_profiles SET isActive = 1 WHERE id = :id")
    suspend fun activateRouter(id: Int)

    @Query("DELETE FROM router_profiles WHERE id = :id")
    suspend fun deleteRouter(id: Int)
}

@Dao
interface VoucherDao {
    @Query("SELECT * FROM vouchers ORDER BY createdAt DESC")
    fun getAllVouchers(): Flow<List<Voucher>>

    @Query("SELECT * FROM vouchers WHERE isUsed = 0 ORDER BY createdAt DESC")
    fun getAvailableVouchers(): Flow<List<Voucher>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertVoucher(voucher: Voucher)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertVouchers(vouchers: List<Voucher>)

    @Update
    suspend fun updateVoucher(voucher: Voucher)

    @Query("DELETE FROM vouchers WHERE id = :id")
    suspend fun deleteVoucher(id: Int)

    @Query("DELETE FROM vouchers")
    suspend fun clearAllVouchers()
}

@Dao
interface MadingDao {
    @Query("SELECT * FROM mading_items ORDER BY timestamp DESC")
    fun getAllMadingItems(): Flow<List<MadingItem>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertMadingItem(item: MadingItem)

    @Query("DELETE FROM mading_items WHERE id = :id")
    suspend fun deleteMadingItem(id: Int)

    @Query("DELETE FROM mading_items")
    suspend fun clearAllMadingItems()
}

@Database(entities = [RouterProfile::class, Voucher::class, MadingItem::class], version = 1, exportSchema = false)
abstract class HotspotDatabase : RoomDatabase() {
    abstract fun routerDao(): RouterDao
    abstract fun voucherDao(): VoucherDao
    abstract fun madingDao(): MadingDao

    companion object {
        @Volatile
        private var INSTANCE: HotspotDatabase? = null

        fun getDatabase(context: Context): HotspotDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    HotspotDatabase::class.java,
                    "hotspot_manager_db"
                )
                .fallbackToDestructiveMigration()
                .build()
                INSTANCE = instance
                instance
            }
        }
    }
}
