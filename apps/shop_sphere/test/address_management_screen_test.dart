import 'package:flutter_test/flutter_test.dart';
import 'package:shop_sphere/providers/session_provider.dart'; // Mengimpor untuk mengakses AddressModel

void main() {
  group('AddressManagementScreen - Sorting Logic', () {
    // Data dummy untuk pengujian
    final nonPrimary1 = AddressModel(id: 'addr1', label: 'Kantor', recipientName: 'User', phoneNumber: '1', fullAddress: 'Addr 1');
    final primaryAddress = AddressModel(id: 'addr2', label: 'Rumah', recipientName: 'User', phoneNumber: '2', fullAddress: 'Addr 2', isPrimary: true);
    final nonPrimary2 = AddressModel(id: 'addr3', label: 'Apartemen', recipientName: 'User', phoneNumber: '3', fullAddress: 'Addr 3');

    // Fungsi pengurutan yang sama persis seperti di widget
    void sortAddresses(List<AddressModel> addresses) {
      addresses.sort((a, b) {
        if (a.isPrimary) return -1; // a harus di atas b
        if (b.isPrimary) return 1;  // b harus di atas a
        return 0; // Urutan lainnya tidak berubah
      });
    }

    test('should place the primary address at the top when it is in the middle', () {
      // Arrange: Alamat utama ada di tengah
      final addresses = [nonPrimary1, primaryAddress, nonPrimary2];

      // Act: Lakukan pengurutan
      sortAddresses(addresses);

      // Assert: Alamat pertama dalam daftar sekarang adalah alamat utama
      expect(addresses.first.id, primaryAddress.id);
      expect(addresses.first.isPrimary, isTrue);
    });

    test('should place the primary address at the top when it is at the end', () {
      // Arrange: Alamat utama ada di akhir
      final addresses = [nonPrimary1, nonPrimary2, primaryAddress];

      // Act: Lakukan pengurutan
      sortAddresses(addresses);

      // Assert: Alamat pertama dalam daftar sekarang adalah alamat utama
      expect(addresses.first.id, primaryAddress.id);
      expect(addresses.first.isPrimary, isTrue);
    });

    test('should keep the primary address at the top if it is already there', () {
      // Arrange: Alamat utama sudah di awal
      final addresses = [primaryAddress, nonPrimary1, nonPrimary2];

      // Act: Lakukan pengurutan
      sortAddresses(addresses);

      // Assert: Alamat pertama dalam daftar tetap alamat utama
      expect(addresses.first.id, primaryAddress.id);
      expect(addresses.first.isPrimary, isTrue);
    });

    test('should not throw an error for an empty list', () {
      // Arrange: Daftar kosong
      final List<AddressModel> addresses = [];

      // Act & Assert: Memastikan tidak ada error yang terjadi
      expect(() => sortAddresses(addresses), returnsNormally);
      expect(addresses.isEmpty, isTrue);
    });
  });
}