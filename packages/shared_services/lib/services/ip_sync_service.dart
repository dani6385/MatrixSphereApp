// File ini bertindak sebagai pengekspor kondisional.
// Ia akan mengekspor implementasi IO (mobile/desktop) secara default.
// Namun, jika aplikasi dikompilasi untuk web (di mana `dart.library.html` tersedia),
// ia akan mengekspor implementasi web sebagai gantinya.

export 'ip_sync_service_io.dart' 
    if (dart.library.html) 'ip_sync_service_web.dart';
