library service_shared;

// 1. Export Firebase Initializer
export 'src/firebase/firebase_initializer.dart';

// 2. Export Service Layer (Abstraksi/Interface & Implementasi)
export 'src/firebase/auth_service.dart';
export 'src/firebase/firestore_service.dart';

// 3. Export Models
export 'src/models/user_model.dart';
export 'src/models/admin_model.dart';

// 4. Export Exceptions (Agar UI bisa menangkap error kustom)
export 'src/exceptions/app_exceptions.dart';

// 5. Export Utility/Constants jika ada
export 'src/utils/firebase_constants.dart';