import 'package:flutter_test/flutter_test.dart';
import 'package:shop_sphere/providers/session_provider.dart';


void main() {
  group('SessionProvider - deleteAddress', () {
    late SessionProvider sessionProvider;

    // Data dummy untuk pengujian
    final address1 = AddressModel(
        id: 'addr1',
        label: 'Rumah',
        recipientName: 'User A',
        phoneNumber: '111',
        fullAddress: 'Jalan Rumah 1',
        isPrimary: true);

    final address2 = AddressModel(
        id: 'addr2',
        label: 'Kantor',
        recipientName: 'User A',
        phoneNumber: '222',
        fullAddress: 'Jalan Kantor 2',
        isPrimary: false);

    final address3 = AddressModel(
        id: 'addr3',
        label: 'Apartemen',
        recipientName: 'User A',
        phoneNumber: '333',
        fullAddress: 'Jalan Apartemen 3',
        isPrimary: false);

    // setUp dijalankan sebelum setiap test
    setUp(() {
      sessionProvider = SessionProvider();
      // Menginisialisasi provider dengan data user dan alamat dummy
      final user = UserModel(
        id: 'user1',
        name: 'Test User',
        email: 'test@example.com',
        addresses: [
          address1,
          address2,
          address3,
        ],
      );
      sessionProvider.setUser(user); // Asumsi ada metode setUser
    });

    test('should delete a non-primary address successfully', () async {
      // Aksi: Hapus alamat yang bukan utama (address2)
      await sessionProvider.deleteAddress('addr2');

      // Verifikasi: Jumlah alamat berkurang menjadi 2
      expect(sessionProvider.user!.addresses.length, 2);
      // Verifikasi: Alamat yang dihapus sudah tidak ada
      expect(sessionProvider.user!.addresses.any((a) => a.id == 'addr2'), isFalse);
      // Verifikasi: Alamat utama tidak berubah
      expect(sessionProvider.user!.addresses.firstWhere((a) => a.isPrimary).id, 'addr1');
    });

    test('should delete a primary address and assign a new primary', () async {
      // Aksi: Hapus alamat utama (address1)
      await sessionProvider.deleteAddress('addr1');

      // Verifikasi: Jumlah alamat berkurang menjadi 2
      expect(sessionProvider.user!.addresses.length, 2);
      // Verifikasi: Alamat yang dihapus sudah tidak ada
      expect(sessionProvider.user!.addresses.any((a) => a.id == 'addr1'), isFalse);
      // Verifikasi: Alamat utama baru telah ditetapkan ke alamat berikutnya (address2)
      expect(sessionProvider.user!.addresses.first.id, 'addr2');
      expect(sessionProvider.user!.addresses.first.isPrimary, isTrue);
    });

    test('should delete the last remaining address', () async {
      // Persiapan: Hanya sisakan satu alamat
      sessionProvider.user!.addresses.removeWhere((a) => a.id != 'addr1');
      expect(sessionProvider.user!.addresses.length, 1);

      // Aksi: Hapus alamat terakhir
      await sessionProvider.deleteAddress('addr1');

      // Verifikasi: Daftar alamat menjadi kosong
      expect(sessionProvider.user!.addresses.isEmpty, isTrue);
    });

    test('should throw an exception when trying to delete a non-existent address', () {
      // Aksi & Verifikasi: Mengharapkan eksepsi ketika mencoba menghapus ID yang tidak ada
      expect(
        () async => await sessionProvider.deleteAddress('non-existent-id'),
        throwsA(isA<Exception>()),
      );
    });

    test('should not change primary if the deleted address was not primary', () async {
      // Aksi: Hapus alamat ke-3 (bukan utama)
      await sessionProvider.deleteAddress('addr3');

      // Verifikasi: Alamat utama tetap address1
      final primaryAddress = sessionProvider.user!.addresses.firstWhere((a) => a.isPrimary);
      expect(primaryAddress.id, 'addr1');
    });
  });
}

/// Catatan:
/// Kode di atas mengasumsikan bahwa `SessionProvider` Anda memiliki metode
/// `setUser(UserModel user)` untuk tujuan pengujian. Jika tidak, Anda perlu
/// menyesuaikan bagian `setUp` agar dapat menginisialisasi data pengguna
/// dengan cara yang sesuai dengan implementasi `SessionProvider` Anda.