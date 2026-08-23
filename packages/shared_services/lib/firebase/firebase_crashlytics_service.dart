import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// A centralized service for handling Firebase Crashlytics reporting.
class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Generic logging utility to print errors to the console during development.
  void _log(dynamic exception, StackTrace? stack, {String? reason, bool fatal = false}) {
    if (kDebugMode) {
      final type = fatal ? 'FATAL ERROR' : 'CAUGHT EXCEPTION';
      print('==================== $type ====================');
      print('Reason: ${reason ?? 'N/A'}');
      print('Exception: $exception');
      print('StackTrace: $stack');
      print('========================================================');
    }
  }

  /// Records a NON-FATAL error. This is for handled exceptions (e.g., in a try-catch block).
  void recordError(dynamic exception, StackTrace? stack, {required String reason}) {
    _log(exception, stack, reason: reason, fatal: false);
    _crashlytics.recordError(exception, stack, reason: reason, fatal: false);
  }

  /// Records a FATAL error from a platform exception (e.g., background tasks).
  void recordFatalError(dynamic exception, StackTrace stack) {
    const reason = 'Platform Fatal Error';
    _log(exception, stack, reason: reason, fatal: true);
    _crashlytics.recordError(exception, stack, reason: reason, fatal: true);
  }

  /// Records a FATAL error from the Flutter framework (e.g., build errors).
  void recordFlutterFatalError(FlutterErrorDetails errorDetails) {
    const reason = 'Flutter Fatal Error';
    _log(errorDetails.exception, errorDetails.stack, reason: reason, fatal: true);
    _crashlytics.recordFlutterFatalError(errorDetails);
  }
}

/// Global instance of the CrashlyticsService to be used throughout the app.
final crashlyticsService = CrashlyticsService();
