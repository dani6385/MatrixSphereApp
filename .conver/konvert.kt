package com.example.data

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "products")
data class Product(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val name: String,
    val description: String,
    val price: Double,
    val category: String,
    val stock: Int,
    val iconName: String // name of material icon to represent it visually
)

@Entity(tableName = "cart_items")
data class CartItem(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val productId: Int,
    val quantity: Int
)

@Entity(tableName = "orders")
data class Order(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val timestamp: Long = System.currentTimeMillis(),
    val status: String = "PENDING_PICKUP", // "PENDING_PICKUP", "PICKED_UP", "CANCELLED"
    val totalPrice: Double,
    val pickupCode: String,
    val shopName: String,
    val shopLatitude: Double,
    val shopLongitude: Double,
    val buyerLatitude: Double,
    val buyerLongitude: Double,
    val pickupDistanceMeters: Double
)

@Entity(tableName = "order_items")
data class OrderItem(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val orderId: Int,
    val productId: Int,
    val productName: String,
    val productPrice: Double,
    val quantity: Int
)

@Entity(tableName = "shop_config")
data class ShopConfig(
    @PrimaryKey val id: Int = 1,
    val name: String = "SS Shop Sphere",
    val address: String = "Grand Indonesia Mall, Lantai 2, Jakarta Pusat",
    val latitude: Double = -6.1953,
    val longitude: Double = 106.8231,
    val maxCheckoutRadiusMeters: Double = 10000.0 // Default 10 km
)

@Entity(tableName = "reviews")
data class Review(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val raterName: String,
    val rating: Int,
    val comment: String,
    val timestamp: Long = System.currentTimeMillis()
)

