class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String category;
  final int stock;
  final String iconName;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stock,
    required this.iconName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'stock': stock,
      'iconName': iconName,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num).toDouble(),
      category: map['category'] ?? '',
      stock: map['stock'] ?? 0,
      iconName: map['iconName'] ?? '',
    );
  }
}

class CartItem {
  final int? id;
  final int productId;
  final int quantity;

  CartItem({
    this.id,
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      productId: map['productId'],
      quantity: map['quantity'],
    );
  }
}

class Order {
  final int? id;
  final int timestamp;
  final String status; // "PENDING_PICKUP", "PICKED_UP", "CANCELLED"
  final double totalPrice;
  final String pickupCode;
  final String shopName;
  final double shopLatitude;
  final double shopLongitude;
  final double buyerLatitude;
  final double buyerLongitude;
  final double pickupDistanceMeters;

  Order({
    this.id,
    int? timestamp,
    this.status = "PENDING_PICKUP",
    required this.totalPrice,
    required this.pickupCode,
    required this.shopName,
    required this.shopLatitude,
    required this.shopLongitude,
    required this.buyerLatitude,
    required this.buyerLongitude,
    required this.pickupDistanceMeters,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'status': status,
      'totalPrice': totalPrice,
      'pickupCode': pickupCode,
      'shopName': shopName,
      'shopLatitude': shopLatitude,
      'shopLongitude': shopLongitude,
      'buyerLatitude': buyerLatitude,
      'buyerLongitude': buyerLongitude,
      'pickupDistanceMeters': pickupDistanceMeters,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      timestamp: map['timestamp'],
      status: map['status'] ?? "PENDING_PICKUP",
      totalPrice: (map['totalPrice'] as num).toDouble(),
      pickupCode: map['pickupCode'] ?? '',
      shopName: map['shopName'] ?? '',
      shopLatitude: (map['shopLatitude'] as num).toDouble(),
      shopLongitude: (map['shopLongitude'] as num).toDouble(),
      buyerLatitude: (map['buyerLatitude'] as num).toDouble(),
      buyerLongitude: (map['buyerLongitude'] as num).toDouble(),
      pickupDistanceMeters: (map['pickupDistanceMeters'] as num).toDouble(),
    );
  }
}

class OrderItem {
  final int? id;
  final int orderId;
  final int productId;
  final String productName;
  final double productPrice;
  final int quantity;

  OrderItem({
    this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      orderId: map['orderId'],
      productId: map['productId'],
      productName: map['productName'] ?? '',
      productPrice: (map['productPrice'] as num).toDouble(),
      quantity: map['quantity'],
    );
  }
}

class ShopConfig {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double maxCheckoutRadiusMeters;

  ShopConfig({
    this.id = 1,
    this.name = "SS Shop Sphere",
    this.address = "Grand Indonesia Mall, Lantai 2, Jakarta Pusat",
    this.latitude = -6.1953,
    this.longitude = 106.8231,
    this.maxCheckoutRadiusMeters = 10000.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'maxCheckoutRadiusMeters': maxCheckoutRadiusMeters,
    };
  }

  factory ShopConfig.fromMap(Map<String, dynamic> map) {
    return ShopConfig(
      id: map['id'] ?? 1,
      name: map['name'] ?? "SS Shop Sphere",
      address: map['address'] ?? "",
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      maxCheckoutRadiusMeters: (map['maxCheckoutRadiusMeters'] as num).toDouble(),
    );
  }
}

class Review {
  final int? id;
  final String raterName;
  final int rating;
  final String comment;
  final int timestamp;

  Review({
    this.id,
    required this.raterName,
    required this.rating,
    required this.comment,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'raterName': raterName,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      raterName: map['raterName'] ?? '',
      rating: map['rating'] ?? 0,
      comment: map['comment'] ?? '',
      timestamp: map['timestamp'],
    );
  }
}