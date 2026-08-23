import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// A centralized service for handling Firebase Analytics.
///
/// This abstract layer helps in keeping the analytics logic consistent across the app
/// and makes it easier to manage, test, or even swap the analytics provider in the future.
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// A navigator observer that can be added to MaterialApp.router to automatically
  /// log screen views.
  FirebaseAnalyticsObserver get analitycsObserver =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Logs a custom event.
  /// Use this for tracking specific user actions that are not covered by the standard events.
  ///
  /// [name]: The name of the event (e.g., 'begin_shop_registration').
  /// [parameters]: A map of key-value pairs that provide more context on the event.
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      if (kDebugMode) {
        print('[ANALYTICS] Logging event: $name, Parameters: $parameters');
      }
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e, stack) {
      // Even if analytics fails, the app should not crash.
      // We can use our crashlytics service to report this failure.
      // Note: Make sure to handle potential circular dependencies if Crashlytics also uses Analytics.
      debugPrint('Error logging analytics event: $e\n$stack');
    }
  }

  /// Logs a 'login' event.
  Future<void> logLogin(String loginMethod) async {
    await logEvent('login', parameters: {'login_method': loginMethod});
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  /// Logs a 'sign_up' event.
  Future<void> logSignUp(String signUpMethod) async {
    await logEvent('sign_up', parameters: {'sign_up_method': signUpMethod});
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  /// Logs a 'purchase' e-commerce event.
  /// Call this when an order is successfully created.
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
    List<AnalyticsEventItem>? items,
  }) async {
    await _analytics.logPurchase(
      transactionId: transactionId,
      value: value,
      currency: currency,
      items: items,
    );
  }

  /// Sets a user property to a given value.
  /// This is useful for segmenting users in your reports.
  ///
  /// [name]: The name of the property (e.g., 'has_shop').
  /// [value]: The value of the property (e.g., 'true').
  Future<void> setUserProperty({required String name, required String? value}) async {
    if (kDebugMode) {
      print('[ANALYTICS] Setting user property: $name, Value: $value');
    }
    await _analytics.setUserProperty(name: name, value: value);
  }
}

/// Global instance of the AnalyticsService to be used throughout the app.
final analyticsService = AnalyticsService();
