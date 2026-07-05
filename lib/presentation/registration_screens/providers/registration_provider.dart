import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Definisikan Model dan Enum di sini agar bisa diakses secara global
enum SortType {
  dateNewest,
  dateOldest,
  nameAsc,
  nameDesc,
}

enum RegistrationStatus { pending, approved, rejected }

class SellerRegistration {
  final String id;
  final String partnerName;
  final String email;
  final DateTime registrationDate;
  final RegistrationStatus status;
  final String? rejectionReason;

  const SellerRegistration({
    required this.id,
    required this.partnerName,
    required this.email,
    required this.registrationDate,
    required this.status,
    this.rejectionReason,
  });

  SellerRegistration copyWith({
    RegistrationStatus? status,
    String? rejectionReason,
  }) {
    return SellerRegistration(
      id: id,
      partnerName: partnerName,
      email: email,
      registrationDate: registrationDate,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}

// 2. Definisikan State untuk Notifier
class RegistrationState {
  final List<SellerRegistration> pendingSellers;
  final List<SellerRegistration> approvedSellers;
  final List<SellerRegistration> rejectedSellers;
  final SortType sortType;
  final String searchQuery;

  const RegistrationState({
    this.pendingSellers = const [],
    this.approvedSellers = const [],
    this.rejectedSellers = const [],
    this.sortType = SortType.dateNewest,
    this.searchQuery = '',
  });

  RegistrationState copyWith({
    List<SellerRegistration>? pendingSellers,
    List<SellerRegistration>? approvedSellers,
    List<SellerRegistration>? rejectedSellers,
    SortType? sortType,
    String? searchQuery,
  }) {
    return RegistrationState(
      pendingSellers: pendingSellers ?? this.pendingSellers,
      approvedSellers: approvedSellers ?? this.approvedSellers,
      rejectedSellers: rejectedSellers ?? this.rejectedSellers,
      sortType: sortType ?? this.sortType,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// 3. Buat StateNotifier untuk mengelola logika
class RegistrationNotifier extends StateNotifier<RegistrationState> {
  // Master list of all registrations, managed internally.
  final List<SellerRegistration> _allRegistrations = [
    SellerRegistration(id: 'seller-001', partnerName: 'Toko Jaya Abadi', email: 'jaya.abadi@email.com', registrationDate: DateTime(2023, 10, 26), status: RegistrationStatus.pending),
    SellerRegistration(id: 'seller-002', partnerName: 'Warung Bu Siti', email: 'siti.warung@email.com', registrationDate: DateTime(2023, 10, 25), status: RegistrationStatus.pending),
    SellerRegistration(id: 'seller-003', partnerName: 'Gadget Store ID', email: 'contact@gadgetstore.id', registrationDate: DateTime(2023, 10, 24), status: RegistrationStatus.approved),
    SellerRegistration(id: 'seller-004', partnerName: 'Kopi Kenangan Senja', email: 'kopi.senja@email.com', registrationDate: DateTime(2023, 10, 22), status: RegistrationStatus.approved),
    SellerRegistration(id: 'seller-005', partnerName: 'Maju Jaya Motor', email: 'cs@majujayamotor.com', registrationDate: DateTime(2023, 10, 20), status: RegistrationStatus.rejected, rejectionReason: 'Data tidak lengkap'),
  ];

  RegistrationNotifier() : super(const RegistrationState()) {
    _filterAndSort();
  }

  void _filterAndSort() {
    List<SellerRegistration> filteredList = _allRegistrations;

    // Apply search
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filteredList = filteredList.where((seller) {
        return seller.partnerName.toLowerCase().contains(query) ||
               seller.email.toLowerCase().contains(query);
      }).toList();
    }

    // Apply sort
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

    // Update state with filtered and sorted lists
    state = state.copyWith(
      pendingSellers: filteredList.where((s) => s.status == RegistrationStatus.pending).toList(),
      approvedSellers: filteredList.where((s) => s.status == RegistrationStatus.approved).toList(),
      rejectedSellers: filteredList.where((s) => s.status == RegistrationStatus.rejected).toList(),
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

  void approveSeller(String sellerId) {
    final index = _allRegistrations.indexWhere((s) => s.id == sellerId);
    if (index != -1) {
      _allRegistrations[index] = _allRegistrations[index].copyWith(status: RegistrationStatus.approved);
      _filterAndSort();
    }
  }

  void rejectSeller(String sellerId, String reason) {
    final index = _allRegistrations.indexWhere((s) => s.id == sellerId);
    if (index != -1) {
      _allRegistrations[index] = _allRegistrations[index].copyWith(status: RegistrationStatus.rejected, rejectionReason: reason);
      _filterAndSort();
    }
  }
}

// 4. Definisikan Provider global
final registrationProvider = StateNotifierProvider<RegistrationNotifier, RegistrationState>((ref) {
  return RegistrationNotifier();
});