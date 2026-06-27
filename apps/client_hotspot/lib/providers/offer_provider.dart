import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/services/firestore_service.dart';

/// Model untuk data penawaran (offer).
class Offer {
  final String id;
  final String title;
  final String subtitle;
  final String tag;
  final Color tagColor;
  final String imageUrl;
  final String semanticLabel;
  final Color bgColor;

  Offer({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
    required this.imageUrl,
    required this.semanticLabel,
    required this.bgColor,
  });

  /// Factory constructor untuk membuat instance Offer dari DocumentSnapshot Firestore.
  factory Offer.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Helper untuk mengubah string hex menjadi Color
    Color hexToColor(String hexString) {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    }

    return Offer(
      id: doc.id,
      title: data['title'] ?? 'Tanpa Judul',
      subtitle: data['subtitle'] ?? '',
      tag: data['tag'] ?? 'INFO',
      tagColor: hexToColor(data['tagColor'] ?? '#808080'),
      imageUrl: data['imageUrl'] ?? '',
      semanticLabel: data['semanticLabel'] ?? 'Gambar penawaran',
      bgColor: hexToColor(data['bgColor'] ?? '#F5F5F5'),
    );
  }
}

class OfferProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  List<Offer> _offers = [];
  bool _isLoading = false;
  String? _errorMessage;

  OfferProvider(this._firestoreService) {
    fetchOffers();
  }

  List<Offer> get offers => _offers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchOffers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final offerDocs = await _firestoreService.getOffers();
      _offers = offerDocs.map((doc) => Offer.fromFirestore(doc)).toList();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Gagal memuat penawaran.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}