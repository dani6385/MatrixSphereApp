import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_services/services/firestore_service.dart';
import 'package:logger/logger.dart';

// Impor model dari file terpusat, bukan mendefinisikannya di sini
import '../models/registration_models.dart';

// Enum juga dipindahkan ke file model
// enum SortType { ... }
// enum RegistrationStatus { ... }
// class SellerRegistration { ... }

// 2. Definisikan State untuk Notifier
class RegistrationState {
  final List<SellerRegistration> pendingSellers;
  final List<SellerRegistration> approvedSellers;
  final List<SellerRegistration> rejectedSellers;
  final SortType sortType;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  const RegistrationState({
    this.pendingSellers = const [],
    this.approvedSellers = const [],
    this.rejectedSellers = const [],
    this.sortType = SortType.dateNewest,
    this.searchQuery = '',
    this.isLoading = true,
    this.errorMessage,
  });

  RegistrationState copyWith({
    List<SellerRegistration>? pendingSellers,
    List<SellerRegistration>? approvedSellers,
    List<SellerRegistration>? rejectedSellers,
    SortType? sortType,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RegistrationState(
      pendingSellers: pendingSellers ?? this.pendingSellers,
      approvedSellers: approvedSellers ?? this.approvedSellers,
      rejectedSellers: rejectedSellers ?? this.rejectedSellers,
      sortType: sortType ?? this.sortType,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// 3. Buat StateNotifier untuk mengelola logika
class RegistrationNotifier extends StateNotifier<RegistrationState> {
  final FirestoreService _firestoreService;
  final Logger _logger = Logger();
  List<SellerRegistration> _allRegistrations = [];

  RegistrationNotifier(this._firestoreService) : super(const RegistrationState()) {
    fetchRegistrations();
  }

  Future<void> fetchRegistrations() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final snapshot = await _firestoreService.getSellerRegistrations();
      // Gunakan factory constructor dari model yang diimpor
      _allRegistrations = snapshot.map((doc) => SellerRegistration.fromFirestore(doc)).toList();
      _filterAndSort();
    } catch (e, stackTrace) {
      _logger.e("Failed to fetch registrations", error: e, stackTrace: stackTrace);
      state = state.copyWith(isLoading: false, errorMessage: "Gagal memuat data pendaftaran.");
    }
  }

  void _filterAndSort() {
    List<SellerRegistration> filteredList = _allRegistrations;

    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filteredList = filteredList.where((seller) {
        return seller.partnerName.toLowerCase().contains(query) || (seller.email?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    switch (state.sortType) {
      case SortType.dateNewest:
        filteredList.sort((a, b) => b.registrationDate.compareTo(a.registrationDate));
        break;
      case SortType.dateOldest:
        filteredList.sort((a, b) => a.registrationDate.compareTo(b.registrationDate));
        break;
      case SortType.nameAsc:
        filteredList.sort((a, b) => a.partnerName.toLowerCase().compareTo(b.partnerName.toLowerCase()));
        break;
      case SortType.nameDesc:
        filteredList.sort((a, b) => b.partnerName.toLowerCase().compareTo(a.partnerName.toLowerCase()));
        break;
    }

    state = state.copyWith(
      pendingSellers: filteredList.where((s) => s.status == RegistrationStatus.pending).toList(),
      approvedSellers: filteredList.where((s) => s.status == RegistrationStatus.approved).toList(),
      rejectedSellers: filteredList.where((s) => s.status == RegistrationStatus.rejected).toList(),
      isLoading: false,
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _filterAndSort();
  }

  void updateSortType(SortType sortType) {
    state = state.copyWith(sortType: sortType);
    _filterAndSort();
  }

  Future<void> approveSeller(String sellerId) async {
    try {
      await _firestoreService.updateSellerRegistration(sellerId, {'status': 'approved'});
      final index = _allRegistrations.indexWhere((s) => s.id == sellerId);
      if (index != -1) {
        _allRegistrations[index] = _allRegistrations[index].copyWith(status: RegistrationStatus.approved);
        _filterAndSort();
      }
    } catch (e) {
      _logger.e("Failed to approve seller $sellerId", error: e);
    }
  }

  Future<void> rejectSeller(String sellerId, String reason) async {
    try {
      await _firestoreService.updateSellerRegistration(sellerId, {
        'status': 'rejected',
        'rejectionReason': reason,
      });
      final index = _allRegistrations.indexWhere((s) => s.id == sellerId);
      if (index != -1) {
        _allRegistrations[index] = _allRegistrations[index].copyWith(
          status: RegistrationStatus.rejected,
          rejectionReason: reason,
        );
        _filterAndSort();
      }
    } catch (e) {
      _logger.e("Failed to reject seller $sellerId", error: e);
    }
  }
}

final firestoreServiceProvider = Provider((ref) => FirestoreService());

final registrationProvider = StateNotifierProvider<RegistrationNotifier, RegistrationState>((ref) {
  return RegistrationNotifier(ref.watch(firestoreServiceProvider));
});
