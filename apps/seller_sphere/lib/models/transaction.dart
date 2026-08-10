// lib/screens/transaction_screen.dart
// Import service ekspor

// Asumsikan model Transaction ada di sini atau diimport dari file model
class Transaction {
  final String id;
  final DateTime date;
  final String type;
  final double amount;
  final String description;
  final String status;
  final List<dynamic>? items; // Menggunakan dynamic karena item bisa berupa Map
  final DateTime timestamp; // Mengganti 'date' menjadi
  Transaction({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.amount,
    required this.description,
    required this.status,
    this.items,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      description: json['description'],
      status: json['status'],
      items: json['items'],
      date: json['date'],
    );
  }
  factory Transaction.fromSnapshot(snapshot) {
    final data = snapshot.value as Map<String, dynamic>;
    return Transaction(
      id: snapshot.key!,
      timestamp: DateTime.parse(data['timestamp']),
      type: data['type'],
      amount: (data['amount'] as num).toDouble(),
      description: data['description'],
      status: data['status'],
      items: data['items'],
      date: DateTime.parse(data['date']), // Assuming 'date' is also a string in the snapshot
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'amount': amount,
      'description': description,
      'status': status,
      'items': items,
      'date': date.toIso8601String(),
    };
  }
  Transaction copyWith({
    String? id,
    DateTime? timestamp,
    String? type,
    double? amount,
    String? description,
    String? status,
    List<dynamic>? items,
    DateTime? date,
  }) {
    return Transaction(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      status: status ?? this.status,
      items: items ?? this.items,
      date: date ?? this.date,
    );
  }
  @override
  String toString() {
    return 'Transaction(id: $id, timestamp: $timestamp, type: $type, amount: $amount, description: $description, status: $status, items: $items, date: $date)';
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transaction &&
        other.id == id &&
        other.timestamp == timestamp &&
        other.type == type &&
        other.amount == amount &&
        other.description == description &&
        other.status == status &&
        // Deep comparison for lists if necessary, or just reference equality
        // For simplicity, assuming reference equality for items or that items
        // themselves are comparable if they are simple types.
        // If items contain complex objects, a deep list comparison would be needed.
        other.items == items &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        timestamp.hashCode ^
        type.hashCode ^
        amount.hashCode ^
        description.hashCode ^
        status.hashCode ^
        items.hashCode ^
        date.hashCode;
  }
}
