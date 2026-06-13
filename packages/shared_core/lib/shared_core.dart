library shared_core;

// Ekspor semua service dan kelas inti dari paket ini
// agar bisa digunakan oleh paket lain dengan satu import.

export 'mikrotik/mikrotik_hotspot.dart'; // <-- Baris ini yang akan memperbaiki error
export 'mikrotik/mikrotik_service.dart'; // Tetap kita ekspor untuk aplikasi admin nanti
